# 0002: Identifier Masking and Hash-Based Deduplication for Privacy (DPDP Compliance)

- **Status**: Accepted
- **Date**: 2026-10-17
- **Context**:
  Under India's Digital Personal Data Protection (DPDP) Act guidelines, financial identifiers (Bank Account Numbers, Demat DP IDs, Mutual Fund Folios, Policy Numbers, PAN) must not be stored or displayed in plaintext to unauthorized viewers or claimants.
  However, the database must prevent an owner from accidentally creating duplicate records if the same statement or receipt is uploaded multiple times.

- **Decision**:
  1. Plaintext financial identifiers are never stored directly in relational table columns.
  2. For display across all UI, APIs, and database views, each record stores a standard masked string in `account_identifier_masked` (e.g., `XXXX-XXXX-1234` or `ABCDE****F`).
  3. For duplicate prevention, the database stores `identifier_hash` as a SHA-256 HMAC or hash of `(institution_id + normalized_raw_number)`.
  4. A composite unique constraint `UNIQUE (estate_id, institution_id, identifier_hash)` is enforced at the database level.

- **Consequences**:
  - **Positive**: High data privacy and DPDP alignment; zero risk of plaintext leaks in logs or views, while preserving strict relational deduplication.
  - **Trade-off**: The system cannot perform substring searches or range queries on raw account numbers; searches must use the masked string suffix or exact hashed matches.
