# 0022: Manual Executor-Signed Estate Archiving

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  After release approval, an estate remains in `RELEASE_APPROVED` while claimants work through their workflows. Eventually it must reach its terminal `ARCHIVED` state, permanently freezing the ledger (ADR 0015).
  Automatically archiving the estate when the last workflow reports `SETTLED` would let software close a legally significant record without a human accountable for it, and would prematurely seal estates whose claims were abandoned rather than settled.
  Under Indian probate practice, the executor remains accountable for the estate's administration until they themselves declare it closed.

- **Decision**:
  1. The `RELEASE_APPROVED` → `ARCHIVED` transition is manual and executes only through the stored procedure `sp_archive_estate(p_estate_id, p_actor_id, p_attestation_note)`.
  2. Only the estate's designated `EXECUTOR` may invoke it.
  3. The procedure aborts unless no claim workflow for the estate remains active; workflows in `PENDING`, `IN_PROGRESS`, `SUBMITTED_TO_INSTITUTION`, or `DISPUTED` block archival until they reach a terminal outcome.
  4. The executor must supply a non-empty attestation note. The procedure records an immutable `AUDIT_ESTATE_ARCHIVED` event carrying the executor's identity, timestamp, and attestation text.
  5. On success, `estate_profile.status = 'ARCHIVED'` and the Estate Freeze Trigger (ADR 0015) applies permanently; all estate records become view-only history.

- **Consequences**:
  - **Positive**: Closure carries explicit human accountability; no premature sealing of a live or unresolved estate; the signed attestation lives permanently in the append-only audit trail; reuses existing freeze-trigger semantics.
  - **Trade-off**: An estate with abandoned claims cannot close until the executor first resolves each workflow to a terminal outcome, so abandoned-claim (lapse) mechanics must be defined.

- **Amendment (ADR 0044)**: Estate archival is automatic after all assigned workflows reach `SETTLED`, `LAPSED`, or `WITHDRAWN`. A disputed or unassigned-succession workflow blocks archival. The executor signature and account are removed.
