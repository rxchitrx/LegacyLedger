# 0015: Database-Enforced Immutability for Released Estates

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  Once an estate release is approved, claim workflows and statutory entitlements are active. Allowing retroactive modifications to assets, ownership shares, or nominee allocations post-release invites legal fraud and database inconsistency.

- **Decision**:
  1. Implement a PostgreSQL `BEFORE UPDATE OR DELETE` trigger on `asset`, `ownership`, and `nomination`.
  2. If the parent `estate_profile.status` is `RELEASE_APPROVED` or `ARCHIVED`, the trigger raises an exception: `RAISE EXCEPTION 'Modifications prohibited: Estate is legally frozen post-release'`.
  3. Status updates on downstream `workflow` and `checklist_item` remain permitted for tracking claim settlement.
  4. The only other permitted exception is the trigger-driven supplementary release of a remediated deferred asset (ADR 0026), which may transition `REQUIRES_MANUAL_REVIEW` / `UNASSIGNED_SUCCESSION` → `RELEASED` solely from within the remediation trigger (`pg_trigger_depth() > 1`).

- **Consequences**:
  - **Positive**: Strict data integrity and legal fidelity; prevents unauthorized tampering even via direct SQL access.
  - **Trade-off**: Corrections to erroneous declarations post-release are handled as append-only correction records (ADR 0028); the original released values remain permanently visible.
