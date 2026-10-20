# 0036: Claimant-Initiated Disputes

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  An institution or another heir may raise an objection, but neither has an app account. The only app roles are owner and claimant, and claimants can access only assigned workflows.

- **Decision**:
  1. A claimant may mark only their own active workflow `DISPUTED` when an institution or legal conflict blocks progress.
  2. The claimant supplies a short description of the objection. The system stores it and writes an immutable `AUDIT_WORKFLOW_DISPUTED` event.
  3. The transition keeps existing read access to the claimant's assigned documents and checklist. No administrative dispute screen or institution account is added.

- **Consequences**:
  - **Positive**: A claimant can record an external objection as soon as it arises without granting access to another person or workflow.
  - **Trade-off**: The app records the claimant's report; it does not verify the institution's position.
