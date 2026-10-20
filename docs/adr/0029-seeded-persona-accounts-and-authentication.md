# 0029: Seeded Persona Accounts and Password Authentication

- **Status**: Superseded in part by ADR 0030 and ADR 0042
- **Date**: 2026-10-20
- **Context**:
  The Streamlit viva demo must demonstrate owner, executor, reviewer, admin, and claimant workflows while preserving deny-by-default authorization. A role selector would make it unclear whether access boundaries belong to an authenticated identity or a UI choice. The project also needs predictable demo setup without public account provisioning.

- **Decision**:
  1. The demo uses seeded accounts only; there is no public self-signup flow.
  2. Each account is linked to one `Person` record and has exactly one fixed system role assigned by seed data. End users cannot change their role.
  3. Seeded accounts authenticate with a unique username and password. Password material is supplied outside the repository; the database stores only salted password hashes, using a maintained password-hashing method.
  4. The original seed set included owner, executor, reviewer, and admin accounts, plus multiple claimant accounts so the viva could demonstrate claimant-specific access.
  5. A nominee acts through a `CLAIMANT` account linked to that nominee's `Person` record. The claimant role alone grants no asset access: access remains scoped by the estate's released workflow and permission records.
  6. Persona changes happen by signing out and signing into another seeded account. There is no in-session role switcher. The authenticated account supplies the actor identity and role for authorization checks and consequential operations.

- **Consequences**:
  - **Positive**: The viva has repeatable identities, clear role boundaries, and a direct way to show that different claimants see different authorized assets.
  - **Trade-off**: This defines a controlled academic demo, not public account registration, account recovery, or production identity management.

- **Supersession note**: ADR 0030 narrows the human account roles to `OWNER` and `CLAIMANT`; the seeded username/password and password-hash decisions remain in force.
