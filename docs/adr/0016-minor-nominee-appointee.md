# 0016: Appointee Representation for Minor Nominees

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  Under Indian succession laws and statutory rules (RBI, IRDAI, SEBI), a minor can be appointed as a nominee, but cannot legally sign discharge receipts or hold claim proceeds directly. An adult appointee/guardian must be nominated to represent the minor.

- **Decision**:
  1. The `nomination` table includes `is_minor (BOOLEAN DEFAULT FALSE)` and `appointee_id (UUID FK -> person, NULLABLE)`.
  2. A `CHECK` constraint enforces that if `is_minor = TRUE`, then `appointee_id IS NOT NULL`.
  3. Upon estate release, claim workflows and actionable checklist tasks for the minor's share are routed to the designated `appointee_id`.

- **Consequences**:
  - **Positive**: Accurately models statutory Indian guardianship requirements with simple foreign key and CHECK constraint enforcement.
  - **Trade-off**: Requires collecting guardian details during nominee registration if a minor is designated.
