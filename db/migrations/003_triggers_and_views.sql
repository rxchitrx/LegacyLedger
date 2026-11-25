-- TRIGGER 1 : Nomination Allocation Cap <= 100% (ADR 0010)
CREATE OR REPLACE FUNCTION fn_check_nomination_cap()
RETURNS TRIGGER AS $$
DECLARE
    current_total NUMERIC(5,2);
BEGIN
    SELECT COALESCE(SUM(allocation_pct), 0)
    INTO current_total
    FROM nomination
    WHERE asset_id = NEW.asset_id AND nominee_person_id <> NEW.nominee_person_id;

    IF (current_total + NEW.allocation_pct) > 100 THEN
        RAISE EXCEPTION 'Total nominee allocation for asset % would be %%% (exceeds 100%%)',
            NEW.asset_id, (current_total + NEW.allocation_pct);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_nomination_allocation_cap
BEFORE INSERT OR UPDATE ON nomination
FOR EACH ROW
EXECUTE FUNCTION fn_check_nomination_cap();

-- TRIGGER 2 : Append-Only Audit Log (ADR 0004)
CREATE OR REPLACE FUNCTION fn_block_audit_mutation()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'audit_event is append-only: % is not permitted', TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_append_only
BEFORE UPDATE OR DELETE ON audit_event
FOR EACH ROW
EXECUTE FUNCTION fn_block_audit_mutation();

-- VIEW 1 : Authorized Claimant Assets (ADR 0018)
CREATE OR REPLACE VIEW v_authorized_claimant_assets AS
SELECT
    wp.claimant_person_id,
    p.display_name AS claimant_name,
    a.asset_id,
    a.asset_type,
    a.account_mask,
    i.name AS institution_name,
    w.workflow_id,
    w.status AS workflow_status,
    wp.access_mode
FROM workflow_permission wp
JOIN person p ON p.person_id = wp.claimant_person_id
JOIN workflow w ON w.workflow_id = wp.workflow_id
JOIN asset_release_notice n ON n.notice_id = w.notice_id
JOIN asset a ON a.asset_id = n.asset_id
JOIN institution i ON i.institution_id = a.institution_id;
