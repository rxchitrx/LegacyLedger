# 0030: Owner-Controlled Estate Setup and Claimant Access

- **Status**: Accepted
- **Date**: 2026-10-20
- **Context**:
  LegacyLedger's earlier role model included executors, reviewers, and administrators. The product is now scoped to two human roles: the owner and claimants. Estate setup and release must work without a third person accessing the app, while claimant access remains private until release.

- **Decision**:
  1. Each owner has exactly one `EstateProfile` containing all of that owner's declared assets and related estate information.
  2. The profile is created only when the owner explicitly chooses **Set up my estate**. Asset registration follows estate setup.
  3. The owner alone adds claimant identities to the estate during setup. Multiple claimants are allowed; a claimant may be a nominee or a legal heir.
  4. Owner designation is sufficient to associate a person with the estate and to make them eligible for app access after release. This association does not establish legal heirship; institution-required legal evidence remains part of the claimant's process checklist.
  5. Claimants receive no access to estate assets before release. After release, access is scoped to their assigned workflows and permission records.
  6. The only human app roles are `OWNER` and `CLAIMANT`. The demo uses seeded accounts for these roles, including multiple claimant accounts. There are no executor, reviewer, or administrator accounts.
  7. A claimant may submit a death certificate to start a release request. The demo checks that it is present/readable and that the deceased person's name matches the owner's recorded name (ADR 0032). If the owner does not veto during the configured veto window, the system approves release automatically; no human reviewer is involved.

- **Consequences**:
  - **Positive**: The estate has one clear owner-controlled setup path, and only owner-designated claimants can gain access after release.
  - **Trade-off**: Existing workflows assigned to executor, reviewer, or administrator roles need a separate decision on whether they become claimant actions, automated system actions, or out-of-app operations.

- **Amendment (ADR 0033)**: When a valid release request starts the veto window, the demo creates a persistent in-app alert and simulated email and WhatsApp delivery records. No external messages or retries are performed.

