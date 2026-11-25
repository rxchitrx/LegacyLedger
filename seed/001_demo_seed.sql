-- 1. Seeded Accounts (salted bcrypt hashes via pgcrypto)
INSERT INTO account (username, password_hash, role) VALUES
    ('arjun.owner',    crypt('owner_demo_pass',    gen_salt('bf')), 'OWNER'),
    ('meera.claimant', crypt('claimant_demo_pass', gen_salt('bf')), 'CLAIMANT');

-- 2. People (Owner, Adult Claimant/Nominee, Minor Nominee)
INSERT INTO person (account_id, display_name) VALUES
    (1, 'Arjun Rao'),
    (2, 'Meera Rao'),
    (NULL, 'Rohan Rao (Minor)');

-- 3. Estate Profile (1 estate per owner)
INSERT INTO estate_profile (owner_person_id, status) VALUES
    (1, 'RELEASE_APPROVED');

-- 4. Institutions
INSERT INTO institution (name) VALUES
    ('HDFC Bank Ltd.'),
    ('CAMS / HDFC Mutual Fund');

-- 5. Assets (masked + keyed HMAC-SHA-256 hash via pgcrypto)
INSERT INTO asset (estate_id, institution_id, asset_type, account_mask, identifier_hash) VALUES
    (1, 1, 'BANK_ACCOUNT', 'XXXX-XXXX-4821',
     encode(hmac('HDFC-4821-SYNTHETIC', 'demo_local_hmac_key', 'sha256'), 'hex')),
    (1, 2, 'MUTUAL_FUND',  'XXXX-9912',
     encode(hmac('CAMS-9912-SYNTHETIC', 'demo_local_hmac_key', 'sha256'), 'hex'));

-- 6. Designations & Ownership Shares
INSERT INTO designation (asset_id, claimant_person_id, claim_route) VALUES
    (1, 2, 'STATUTORY_NOMINEE'),
    (2, 2, 'STATUTORY_NOMINEE');

INSERT INTO ownership_share (asset_id, person_id, ownership_share) VALUES
    (1, 1, 100.00),
    (2, 1, 100.00);

-- 7. Nominations on Asset 1: 60% (Meera) + 40% (Rohan, minor with Meera as appointee) = 100%
INSERT INTO nomination (asset_id, nominee_person_id, appointee_person_id, allocation_pct, is_minor) VALUES
    (1, 2, NULL, 60.00, FALSE),
    (1, 3, 2,    40.00, TRUE);

-- 8. Document, Release Request, Notice, Rule, Workflow & Permission
INSERT INTO document (uploader_person_id, document_type) VALUES
    (2, 'DEATH_CERTIFICATE');

INSERT INTO document_asset (document_id, asset_id) VALUES
    (1, 1), (1, 2);

INSERT INTO release_request (
    claimant_person_id, estate_id, certificate_document_id,
    status, certificate_check_outcome, veto_started_at, veto_deadline_at
) VALUES (
    2, 1, 1, 'APPROVED', 'PASSED', NOW() - INTERVAL '5 minutes', NOW() - INTERVAL '3 minutes'
);

INSERT INTO notification (request_id, channel, status) VALUES
    (1, 'IN_APP', 'DELIVERED'),
    (1, 'EMAIL', 'SIMULATED_LOGGED'),
    (1, 'WHATSAPP', 'SIMULATED_LOGGED');

INSERT INTO asset_release_notice (request_id, asset_id, outcome) VALUES
    (1, 1, 'RELEASED'),
    (1, 2, 'RELEASED');

INSERT INTO process_rule (version) VALUES ('RBI-2026-v1'), ('SEBI-2026-v1');
INSERT INTO guidance_source (version) VALUES ('RBI-MasterDir-2025'), ('SEBI-CAS-2025');
INSERT INTO rule_source (rule_id, source_id) VALUES (1, 1), (2, 2);
INSERT INTO rule_requirement (rule_id, required, waiver) VALUES
    (1, TRUE, NULL),
    (2, TRUE, 'Threshold < Rs 5L');

INSERT INTO workflow (notice_id, rule_id, status) VALUES
    (1, 1, 'IN_PROGRESS'),
    (2, 2, 'PENDING');

INSERT INTO workflow_permission (workflow_id, claimant_person_id, access_mode) VALUES
    (1, 2, 'READ_WRITE'),
    (2, 2, 'READ_WRITE');

INSERT INTO checklist_item (workflow_id, requirement_id, status) VALUES
    (1, 1, 'COMPLETED'),
    (2, 2, 'PENDING');

-- 9. Initial Audit Event
INSERT INTO audit_event (action, actor_ref, target_type, target_ref) VALUES
    ('ESTATE_RELEASE_APPROVED', NULL, 'ESTATE_PROFILE', '1');
