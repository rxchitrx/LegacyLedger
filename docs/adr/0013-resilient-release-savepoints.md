# 0013: Resilient Estate Release via Savepoints and Asset-Level Triage

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  An estate often contains heterogeneous assets (bank FDs, mutual fund folios, demat accounts, insurance policies). One asset might have missing documentation or an unlinked process rule, while three other assets are completely verified with unambiguous nominees.
  A strict all-or-nothing rollback (aborting release of the entire estate because of an issue on a single minor asset) strands grieving claimants and blocks timely transmission of ready assets.
  However, for academic DBMS evaluation, robust ACID transactional control (demonstrating `BEGIN`, `SAVEPOINT`, and `ROLLBACK TO SAVEPOINT`) must still be actively demonstrated.

- **Decision**:
  1. The overall release operation runs inside a master PostgreSQL transaction managed by `sp_execute_atomic_release`.
  2. The procedure loops through the estate's declared assets using SQL savepoints (`SAVEPOINT asset_release_sp`).
  3. For each asset:
     - If the asset is in `READY` status with full nominee allocations and verified rules, its `workflow`, `checklist_item`, and claimant `permission` rows are generated cleanly.
     - If an individual asset encounters an anomaly (e.g., `INCOMPLETE_DOCUMENTATION`, missing rule mapping, or exception), the transaction executes `ROLLBACK TO SAVEPOINT asset_release_sp` for that specific asset only.
      - The problematic asset is updated to `REQUIRES_MANUAL_REVIEW` (recovered automatically upon remediation, ADR 0026), and an explanatory notice is added to the estate release summary.
  4. The overarching `estate_profile.status` moves to `RELEASE_APPROVED` so claimants can immediately begin processing claims for all cleared assets.
  5. If an unrecoverable system-level error occurs (e.g. database disk/connection failure or corruption of the core estate record itself), the entire transaction executes a full `ROLLBACK`.

- **Consequences**:
  - **Positive**: Maximizes real-world claimant utility (claimants are not blocked on healthy assets due to an isolated issue on one asset); simultaneously showcases advanced DBMS concepts (savepoints, partial rollback, and robust exception handling).
  - **Trade-off**: Requires structured procedural logic handling per-asset savepoints within the stored procedure.

- **Amendment (ADR 0040)**: Asset-level release notices are stored as structured relational records and rendered in a read-only release summary scoped to the owner or each claimant’s assigned workflows.
