# 0028: Post-Release Corrections as Append-Only Records

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  ADR 0015 freezes `asset`, `ownership`, and `nomination` rows once an estate is `RELEASE_APPROVED` or `ARCHIVED`, but its trade-off left open how erroneous declarations discovered after release are corrected. Editing frozen rows (via an administrative unfreeze) would rewrite the legal record of what was released and break trust in the immutable history.

- **Decision**:
  1. Frozen rows are never modified or deleted — there is no unfreeze path for them.
  2. To correct erroneous data on a frozen estate, an `ADMIN` records a correction as a new append-only row capturing: the actor (who), timestamp (when), mandatory reason (why), the target entity and field, the old value, and the new value.
  3. The original released values remain stored permanently, so both original and corrected values are always available for audit and dispute.
  4. Reads and screens present the corrected (effective) value, with each correction written as an immutable audit event under the same rules as other consequential operations (ADR 0004).

- **Consequences**:
  - **Positive**: The freeze guarantee stays absolute; corrections are fully traceable (who, when, why, old → new); disputes can reconstruct exactly what was originally released versus what the system now reports.
  - **Trade-off**: User-facing reads must resolve corrections, and screens must make clear when a value is a corrected one.

- **Amendment (ADR 0044)**: A claimant may append a reasoned correction only for an asset linked to their own workflow. The original remains unchanged; the claimant-provided value is labeled unverified and scoped to authorized readers. The admin actor is removed.
