# 0010: Database Trigger Enforcing Nominee Allocation Cap (<= 100%)

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  Under Indian financial regulations (e.g., SEBI guidelines on mutual funds and RBI guidelines on bank nominations), an investor can appoint multiple nominees and assign specific share percentages. The sum of all shares must not exceed 100%.
  For the academic DBMS course evaluation, database-level triggers must be demonstrated to prevent illegal financial state transitions independently of frontend or application-layer validation.

- **Decision**:
  1. A PostgreSQL `BEFORE INSERT OR UPDATE` trigger (`trg_enforce_nominee_allocation_cap`) is attached to the `nomination` table.
  2. The trigger computes the prospective sum of `allocation_percentage` for the target `asset_id`.
  3. If $\sum(\text{allocation\_percentage}) > 100.00$, the trigger immediately raises a database exception (`RAISE EXCEPTION 'Total nominee allocation for asset % cannot exceed 100%% (attempted: %%)', ...`), aborting the transaction.
  4. Allocation sums strictly below 100.00% are permitted during draft states, but the parent asset retains a computed or stored flag (`is_allocation_complete = FALSE`) preventing release approval until full allocation or explicit residual devolution to legal heirs is confirmed (ADR 0025).

- **Consequences**:
  - **Positive**: Direct demonstration of active DBMS trigger constraints; eliminates arithmetic over-allocation vulnerabilities at the storage engine level.
  - **Trade-off**: Requires bulk updates to adjust percentages simultaneously or sequential inserts carefully ordered below the 100% threshold.
