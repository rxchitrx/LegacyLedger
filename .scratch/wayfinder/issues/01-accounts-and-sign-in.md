# 01: Accounts and sign-in for every persona

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

How does each kind of user get an account, sign in, and hold a role — owner, executor, reviewer, admin, claimant (including a nominee acting as claimant) — and how does the demo switch between personas?

Undecided: account provisioning (self-signup, owner invite, or seeded demo accounts), credentials and auth mechanism, role assignment, and the persona-switching pattern for the viva demo.

**Relevant refs:** CONTEXT.md "System Role" and "Persona Swapping"; no ADR covers accounts or authentication. This is the question parked earlier in the grill session.

## Resolution

Accepted in [ADR 0029: Seeded Persona Accounts and Password Authentication](../../../docs/adr/0029-seeded-persona-accounts-and-authentication.md). The demo uses seeded accounts with unique usernames/passwords, one fixed role per account, and each account linked to a `Person`. Password material stays outside the repository; only salted hashes are stored. Persona changes use sign-out/sign-in. The seed set includes multiple claimant accounts, whose access is still limited by released workflow and permission records.

**Scope correction:** Following [ADR 0030: Owner-Controlled Estate Setup and Claimant Access](../../../docs/adr/0030-owner-controlled-estate-and-claimant-access.md), only `OWNER` and `CLAIMANT` are human app roles. The credential and seeded-account decisions above remain; executor, reviewer, and admin accounts are removed from the demo.
