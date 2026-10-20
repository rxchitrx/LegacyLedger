# 0021: Non-Destructive Escalation for Disputed Workflows

- **Status**: Superseded in part by ADR 0036
- **Date**: 2026-10-18
- **Context**:
  During post-release claims, institutional objections (e.g. signature discrepancies at bank branches) or conflicting claims by other legal heirs can stall transmission.
  Revoking claimant permissions upon a dispute blocks them from inspecting the exact documentation needed to address the objection.

- **Decision**:
  1. Transitioning a workflow to `DISPUTED` updates the `workflow.status` without revoking read access to supporting documents or existing checklist items.
  2. Disputed workflows are surfaced in an administrative supervisory view (`v_disputed_workflows`).
  3. The claimant's dashboard dynamically renders regulatory escalation guidance (e.g., RBI Integrated Ombudsman Scheme contacts, AMC nodal escalation matrix, and legal heir affidavit requirements).
  4. An immutable `AUDIT_WORKFLOW_DISPUTED` event is logged with the claimant's objection notes.

- **Consequences**:
  - **Positive**: Maintains visibility for the claimant to rectify objections; cleanly tracks disputed cases for executor supervision.
  - **Trade-off**: Requires modeling status-conditional guidance blocks in the frontend view.

- **Amendment (ADR 0036)**: Only the claimant assigned to the workflow may mark it disputed and describe an external institutional/legal objection. The admin supervisory view is removed; claimants see only their own disputed workflow.
