CREATE TABLE document (
    document_id BIGSERIAL PRIMARY KEY,
    uploader_person_id BIGINT NOT NULL REFERENCES person(person_id),
    document_type TEXT NOT NULL
);

CREATE TABLE document_asset (
    document_id BIGINT NOT NULL REFERENCES document(document_id) ON DELETE CASCADE,
    asset_id BIGINT NOT NULL REFERENCES asset(asset_id),
    PRIMARY KEY (document_id, asset_id)
);

CREATE TABLE release_request (
    request_id BIGSERIAL PRIMARY KEY,
    claimant_person_id BIGINT NOT NULL REFERENCES person(person_id),
    estate_id BIGINT NOT NULL REFERENCES estate_profile(estate_id),
    certificate_document_id BIGINT NOT NULL REFERENCES document(document_id),
    status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'APPROVED', 'CANCELLED_BY_VETO')),
    certificate_check_outcome TEXT NOT NULL
        CHECK (certificate_check_outcome IN ('PASSED', 'FAILED')),
    veto_started_at TIMESTAMPTZ,
    veto_deadline_at TIMESTAMPTZ
);

CREATE TABLE notification (
    notification_id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL REFERENCES release_request(request_id),
    channel TEXT NOT NULL CHECK (channel IN ('IN_APP', 'EMAIL', 'WHATSAPP')),
    status TEXT NOT NULL
);

CREATE TABLE asset_release_notice (
    notice_id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL REFERENCES release_request(request_id),
    asset_id BIGINT NOT NULL REFERENCES asset(asset_id),
    outcome TEXT NOT NULL CHECK (outcome IN ('RELEASED', 'DEFERRED'))
);

CREATE TABLE process_rule (
    rule_id BIGSERIAL PRIMARY KEY,
    version TEXT NOT NULL
);

CREATE TABLE guidance_source (
    source_id BIGSERIAL PRIMARY KEY,
    version TEXT NOT NULL
);

CREATE TABLE rule_source (
    rule_id BIGINT NOT NULL REFERENCES process_rule(rule_id),
    source_id BIGINT NOT NULL REFERENCES guidance_source(source_id),
    PRIMARY KEY (rule_id, source_id)
);

CREATE TABLE rule_requirement (
    requirement_id BIGSERIAL PRIMARY KEY,
    rule_id BIGINT NOT NULL REFERENCES process_rule(rule_id),
    required BOOLEAN NOT NULL DEFAULT TRUE,
    waiver TEXT
);

CREATE TABLE workflow (
    workflow_id BIGSERIAL PRIMARY KEY,
    notice_id BIGINT NOT NULL REFERENCES asset_release_notice(notice_id),
    rule_id BIGINT NOT NULL REFERENCES process_rule(rule_id),
    status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (status IN (
            'PENDING', 'IN_PROGRESS', 'SUBMITTED_TO_INSTITUTION',
            'SETTLED', 'DISPUTED', 'WITHDRAWN', 'LAPSED'
        ))
);

CREATE TABLE workflow_permission (
    workflow_id BIGINT NOT NULL REFERENCES workflow(workflow_id),
    claimant_person_id BIGINT NOT NULL REFERENCES person(person_id),
    access_mode TEXT NOT NULL CHECK (access_mode IN ('READ_WRITE', 'READ_ONLY')),
    PRIMARY KEY (workflow_id, claimant_person_id)
);

CREATE TABLE checklist_item (
    item_id BIGSERIAL PRIMARY KEY,
    workflow_id BIGINT NOT NULL REFERENCES workflow(workflow_id),
    requirement_id BIGINT NOT NULL REFERENCES rule_requirement(requirement_id),
    status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'COMPLETED', 'WAIVED'))
);

CREATE TABLE correction (
    correction_id BIGSERIAL PRIMARY KEY,
    workflow_id BIGINT NOT NULL REFERENCES workflow(workflow_id),
    claimant_person_id BIGINT NOT NULL REFERENCES person(person_id),
    unverified BOOLEAN NOT NULL DEFAULT TRUE CHECK (unverified = TRUE)
);

CREATE TABLE audit_event (
    event_id BIGSERIAL PRIMARY KEY,
    action TEXT NOT NULL,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    actor_ref TEXT,
    target_type TEXT NOT NULL,
    target_ref TEXT NOT NULL
);
