# 0042: Two-Portal Screen Inventory

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  Earlier UI plans included reviewer, executor, administrator, and DBMS inspector screens. The accepted account model has only `OWNER` and `CLAIMANT` roles; the user wants only those two people accessing the app.

- **Decision**:
  1. The app screens are sign-in/sign-out, the Owner Portal, and the Claimant Portal. The Owner Portal contains estate setup, assets/documents and extraction review, claimant assignments, release/veto notices, release summary, and privacy requests. The Claimant Portal contains release-request filing, assigned claims/checklists/documents/guidance, disputes, correction submissions, withdrawal, notifications, scoped release summary, and privacy requests.
  2. Remove reviewer, executor, administrator, and in-app DBMS inspector screens. Database inspection for the academic demonstration uses external PostgreSQL/MongoDB tools, not a third app persona.
  3. Each portal shows only the actions and records authorized for that role and account.

- **Consequences**:
  - **Positive**: The interface matches the two-role account model and does not imply extra people operate the estate.
  - **Trade-off**: Database inspection requires a separate development or viva tool.
