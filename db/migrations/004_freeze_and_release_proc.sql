-- ==========================================
-- TRIGGER 3: Estate Freeze Post-Release (ADR 0015)
-- ==========================================
CREATE OR REPLACE FUNCTION fn_enforce_estate_freeze()
RETURNS TRIGGER AS $$
DECLARE
    v_estate_id BIGINT;
    v_status    TEXT;
BEGIN
    IF TG_TABLE_NAME = 'asset' THEN
        v_estate_id := OLD.estate_id;
    ELSE
        SELECT estate_id INTO v_estate_id
        FROM asset
        WHERE asset_id = OLD.asset_id;
    END IF;

    SELECT status INTO v_status
    FROM estate_profile
    WHERE estate_id = v_estate_id;

    IF v_status IN ('RELEASE_APPROVED', 'ARCHIVED') THEN
        RAISE EXCEPTION 'Estate % is frozen (%): % on % is not permitted',
            v_estate_id, v_status, TG_OP, TG_TABLE_NAME;
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_freeze_asset
BEFORE UPDATE OR DELETE ON asset
FOR EACH ROW EXECUTE FUNCTION fn_enforce_estate_freeze();

CREATE TRIGGER trg_freeze_ownership
BEFORE UPDATE OR DELETE ON ownership_share
FOR EACH ROW EXECUTE FUNCTION fn_enforce_estate_freeze();

CREATE TRIGGER trg_freeze_nomination
BEFORE UPDATE OR DELETE ON nomination
FOR EACH ROW EXECUTE FUNCTION fn_enforce_estate_freeze();

-- ==========================================
-- STORED PROCEDURE: Atomic Estate Release (ADR 0013)
-- ==========================================
CREATE OR REPLACE PROCEDURE sp_execute_atomic_release(p_request_id BIGINT)
LANGUAGE plpgsql AS $$
DECLARE
    v_estate_id   BIGINT;
    v_req_status  TEXT;
    v_check       TEXT;
    v_asset       RECORD;
    v_claimant_id BIGINT;
    v_notice_id   BIGINT;
    v_wf_id       BIGINT;
BEGIN
    -- Lock the release request row to prevent race conditions with owner veto
    SELECT estate_id, status, certificate_check_outcome
    INTO v_estate_id, v_req_status, v_check
    FROM release_request
    WHERE request_id = p_request_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Release request % not found', p_request_id;
    END IF;
    IF v_req_status <> 'PENDING' OR v_check <> 'PASSED' THEN
        RAISE EXCEPTION 'Release request % is not eligible (status=%, check=%)',
            p_request_id, v_req_status, v_check;
    END IF;

    UPDATE release_request SET status = 'APPROVED' WHERE request_id = p_request_id;
    UPDATE estate_profile  SET status = 'RELEASE_APPROVED' WHERE estate_id = v_estate_id;

    -- Process each asset: release designated assets, defer unassigned ones
    FOR v_asset IN SELECT asset_id FROM asset WHERE estate_id = v_estate_id LOOP
        SELECT claimant_person_id INTO v_claimant_id
        FROM designation
        WHERE asset_id = v_asset.asset_id
        LIMIT 1;

        IF v_claimant_id IS NULL THEN
            INSERT INTO asset_release_notice (request_id, asset_id, outcome)
            VALUES (p_request_id, v_asset.asset_id, 'DEFERRED');
        ELSE
            INSERT INTO asset_release_notice (request_id, asset_id, outcome)
            VALUES (p_request_id, v_asset.asset_id, 'RELEASED')
            RETURNING notice_id INTO v_notice_id;

            INSERT INTO workflow (notice_id, rule_id, status)
            VALUES (v_notice_id, 1, 'PENDING')
            RETURNING workflow_id INTO v_wf_id;

            INSERT INTO workflow_permission (workflow_id, claimant_person_id, access_mode)
            VALUES (v_wf_id, v_claimant_id, 'READ_WRITE');
        END IF;
    END LOOP;

    INSERT INTO audit_event (action, actor_ref, target_type, target_ref)
    VALUES ('ATOMIC_RELEASE_EXECUTED', NULL, 'ESTATE_PROFILE', v_estate_id::TEXT);
END;
$$;
