# 0024: Bifurcated Dispute Exit — Claimant Resumption and Executor Closure

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  ADR 0021 covers entering `DISPUTED` (non-destructive escalation with retained read access) and ADR 0023 requires disputes to exit before lapse or archiving can occur, but no exit rule existed.
  The actual legal resolution (corrected KYC, court order, succession certificate) always happens offline at the institution; the ledger only records the outcome.
  Two distinct interests exist: the claimant decides whether to keep pursuing the claim after the objection, and the executor decides whether an unresolved objection should permanently close the claim.

- **Decision**:
  1. A single stored procedure `sp_close_dispute(p_actor_id, p_workflow_id, p_outcome, p_note)` is the only exit from `DISPUTED`, with a mandatory non-empty note.
  2. Outcome `RESUMED` requires the actor to be the workflow's claimant. The workflow returns to `IN_PROGRESS` and resumes its normal lifecycle, becoming lapse-eligible again only through the inactivity gate (ADR 0023). Logs an immutable `AUDIT_WORKFLOW_DISPUTE_RESOLVED` event.
  3. Outcome `LAPSED` requires the actor to be the estate's designated executor. This is an explicit closure decision, not an inactivity lapse: the executor uses it when an objection remains unresolved and the claimant is not pursuing it. Logs an immutable `AUDIT_WORKFLOW_LAPSED` event recording `prior_status = 'DISPUTED'`.
  4. Neither party can exercise the other's authority: a claimant cannot close a disputed workflow as lapsed, and an executor cannot resume it to `IN_PROGRESS` on the claimant's behalf.
  5. Dispute closure fields (`dispute_outcome`, `dispute_resolution_note`, `dispute_closed_at`) are stored on the workflow row for reporting.

- **Consequences**:
  - **Positive**: Crisp authority separation to demonstrate deny-by-default authorization in the viva; every dispute has a defined, audited exit; the executor always has a terminating path so disputes cannot block archiving forever.
  - **Trade-off**: A claimant who wishes to withdraw a disputed claim entirely must rely on the executor closing it; claimant self-withdrawal is not modeled.

- **Amendment (ADR 0044)**: The assigned claimant alone may resume their disputed workflow with a resolution note or withdraw it without a reason. Executor closure is removed; withdrawal follows ADR 0038.
