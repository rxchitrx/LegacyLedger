CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE account (
    account_id BIGSERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('OWNER', 'CLAIMANT'))
);

CREATE TABLE person (
    person_id BIGSERIAL PRIMARY KEY,
    account_id BIGINT UNIQUE REFERENCES account(account_id),
    display_name TEXT NOT NULL
);

CREATE TABLE estate_profile (
    estate_id BIGSERIAL PRIMARY KEY,
    owner_person_id BIGINT NOT NULL UNIQUE REFERENCES person(person_id),
    status TEXT NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE', 'PENDING_VERIFICATION', 'DISPUTED', 'RELEASE_APPROVED', 'ARCHIVED'))
);

CREATE TABLE institution (
    institution_id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE asset (
    asset_id BIGSERIAL PRIMARY KEY,
    estate_id BIGINT NOT NULL REFERENCES estate_profile(estate_id),
    institution_id BIGINT NOT NULL REFERENCES institution(institution_id),
    asset_type TEXT NOT NULL,
    account_mask TEXT NOT NULL,
    identifier_hash TEXT NOT NULL,
    UNIQUE (institution_id, identifier_hash)
);

CREATE TABLE designation (
    asset_id BIGINT NOT NULL REFERENCES asset(asset_id),
    claimant_person_id BIGINT NOT NULL REFERENCES person(person_id),
    claim_route TEXT NOT NULL,
    PRIMARY KEY (asset_id, claimant_person_id)
);

CREATE TABLE ownership_share (
    asset_id BIGINT NOT NULL REFERENCES asset(asset_id),
    person_id BIGINT NOT NULL REFERENCES person(person_id),
    ownership_share NUMERIC(5,2) NOT NULL CHECK (ownership_share > 0 AND ownership_share <= 100),
    PRIMARY KEY (asset_id, person_id)
);

CREATE TABLE nomination (
    asset_id BIGINT NOT NULL REFERENCES asset(asset_id),
    nominee_person_id BIGINT NOT NULL REFERENCES person(person_id),
    appointee_person_id BIGINT REFERENCES person(person_id),
    allocation_pct NUMERIC(5,2) NOT NULL CHECK (allocation_pct > 0 AND allocation_pct <= 100),
    is_minor BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (asset_id, nominee_person_id),
    CHECK (NOT is_minor OR appointee_person_id IS NOT NULL)
);
