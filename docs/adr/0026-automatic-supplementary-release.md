# 0026: Trigger-Driven Automatic Supplementary Release for Remediated Assets

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  ADR 0013 defers problematic assets to `REQUIRES_MANUAL_REVIEW` so healthy assets can release, but ADR 0015's freeze trigger blocks the asset updates any recovery would need — deferred assets had no path back into the claim lifecycle.
  The defects that defer an asset are mechanical and binary: a verified supporting document missing, no active `process_rule` matching the asset, no registered executor/legal heir for an un-nominated asset. Claim routing itself is fully deterministic (ADR 0003), so once prerequisites become true there is no discretionary decision left to make — only mechanical workflow generation.
  A human approval step for this would add ceremony without adding judgment, while still needing the same freeze exemption.

- **Decision**:
  1. The per-asset routing logic (survivor precedence, nominee shares, residual fallback, un-nominated fallback, checklist/permission/workflow generation) is factored into one shared PL/pgSQL function used identically by `sp_execute_atomic_release` and the remediation path.
  2. A trigger (`trg_auto_supplementary_release`) fires after remediation events affecting a deferred asset while its estate status is `RELEASE_APPROVED`:
     - a verified document becomes linked to the asset;
     - a matching active `process_rule` is inserted or activated;
     - an estate executor/legal heir is registered (covers `UNASSIGNED_SUCCESSION` assets).
     The trigger re-evaluates full release readiness; only when every prerequisite holds does it run the shared routing logic, set the asset to `RELEASED`, and write an immutable `AUDIT_ASSET_SUPPLEMENTARY_RELEASED` event.
  3. Routing runs inside a PL/pgSQL exception block (implicit savepoint): on failure the asset stays deferred, an `AUDIT_SUPPLEMENTARY_RELEASE_FAILED` event is recorded, and the user's remediation (e.g. document upload) is never rolled back.
  4. The freeze trigger (ADR 0015) is amended to permit an asset update only when all of the following hold: estate status is `RELEASE_APPROVED` (never `ARCHIVED`); the update is executed from within the remediation trigger (`pg_trigger_depth() > 1`, impossible from client SQL); and the transition is `REQUIRES_MANUAL_REVIEW` / `UNASSIGNED_SUCCESSION` → `RELEASED`. Every other post-release mutation stays blocked.
  5. Audit events carry the remediating actor where the triggering row identifies one (e.g. the document's uploader/verifier), otherwise `NULL` as a system action.
  6. The trigger is idempotent: a remediation event on an already-`RELEASED` asset is a no-op.

- **Consequences**:
  - **Positive**: Deferred assets regain a complete lifecycle with zero human ceremony; the viva can demonstrate "fix the defect, watch the workflows materialize"; the freeze guarantee remains intact because the exemption is only reachable from trigger depth and only for the one safe transition.
  - **Trade-off**: Initial and supplementary release must share one routing function to stay consistent; trigger chains add subtle failure modes, which is why both success and failure paths write audit events.

- **Amendment (ADR 0044)**: Supplementary release remains automatic for verified-document and process-rule remediation. The executor/legal-heir registration trigger is removed; claimant assignments lock at release request, and an unassigned-succession workflow cannot be assigned after release.
