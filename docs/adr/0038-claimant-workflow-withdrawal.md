# 0038: Claimant Workflow Withdrawal

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  A claimant may decide to stop pursuing their own claim. The app must distinguish that choice from an inactivity lapse, while preserving an audit trail. The user explicitly chose that withdrawal must not require a reason.

- **Decision**:
  1. Add `WITHDRAWN` as a terminal workflow state. A claimant may withdraw their own workflow from any non-terminal state, including `DISPUTED`, without providing a reason.
  2. The system records the claimant, timestamp, and an optional note in an immutable `AUDIT_WORKFLOW_WITHDRAWN` event. The workflow becomes read-only history.
  3. If the workflow was already submitted to an institution, withdrawal closes only the app's tracking; it does not cancel or represent cancellation of the external filing.
  4. A settled or lapsed workflow cannot be withdrawn.

- **Consequences**:
  - **Positive**: Claimants can end their own app workflow without another person or a required explanation.
  - **Trade-off**: An institution may continue processing a claim after the claimant withdraws it in the app.
