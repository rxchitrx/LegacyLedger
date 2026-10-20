# 0023: Gated Executor Lapse for Abandoned Claim Workflows

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  ADR 0022 gates estate archiving on all workflows reaching a terminal state, but the lifecycle (ADR 0009) had no way to terminate a claim that a claimant simply abandons: no checklist activity, no institutional filing, no response. `PENDING`, `IN_PROGRESS`, and `SUBMITTED_TO_INSTITUTION` could otherwise persist forever, permanently blocking archiving.
  CONTEXT.md already defines archiving as occurring "once all claim workflows are settled or lapsed", so lapse semantics must exist.

- **Decision**:
  1. A `LAPSED` terminal state is added to the `workflow.status` enum.
  2. Only the estate's designated `EXECUTOR` may lapse a workflow, and only via `sp_lapse_workflow(p_actor_id, p_workflow_id, p_reason)`.
  3. A workflow is lapse-eligible only when all of the following hold:
     - Its status is `PENDING`, `IN_PROGRESS`, or `SUBMITTED_TO_INSTITUTION`;
     - Its last activity (most recent of the workflow record and any of its `checklist_item` updates) is older than the configured lapse threshold (system configuration; default 180 days; shortened for demo);
     - A non-empty lapse reason is supplied.
  4. `DISPUTED` workflows are never lapse-eligible through this inactivity gate; they exit only through explicit dispute closure (ADR 0024): the claimant may resume the claim, or the executor may close it as lapsed.
  5. The procedure sets `status = 'LAPSED'`, records `lapsed_at` and `lapse_reason`, and writes an `AUDIT_WORKFLOW_LAPSED` event carrying the executor's identity and reason.
  6. Lapsed workflows are read-only history: all mutating stored procedures reject state transitions on terminal workflows (`SETTLED`, `LAPSED`), while existing visibility and audit records are retained.
  7. A view `v_lapse_eligible_workflows` surfaces stalled claims with their days-since-last-activity so the executor acts deliberately rather than blindly.

- **Consequences**:
  - **Positive**: Completes the workflow state machine; gives estates a legitimate path to `ARCHIVED` without fabricating settlements; keeps the executor formally accountable with a permanent, reasoned audit record.
  - **Trade-off**: The inactivity window is an operational policy that must be configured; evaluation requires deliberately shortening it to demonstrate lapse live.

- **Amendment (ADR 0034 / 0044)**: The claim-inactivity threshold lives in project/deployment configuration and is 180 days in the demo. ADR 0044 defines the system lapse action and audit reason; no executor role is restored.

- **Amendment (ADR 0044)**: The system lapses eligible assigned, non-disputed workflows after 180 days without activity and records a system audit event with a fixed inactivity reason. No executor action or claimant-supplied reason is required; disputed and unassigned-succession workflows do not auto-lapse.
