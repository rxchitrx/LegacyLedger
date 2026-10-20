# 14: Full screen inventory (including executor and admin)

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

Which screens exist in total?

The UI decision names only Owner Portal, Reviewer Console, Claimant Portal, and DBMS Inspector — but ADRs 0022–0028 give the executor and admin concrete duties with no screens to do them on.

Undecided: the full screen list per role and what each shows.

**Relevant refs:** ADR 0005 (the four tabs), ADRs 0022–0028 (executor/admin duties: `sp_archive_estate`, `sp_lapse_workflow`, `sp_admin_reopen_estate`, correction records, release decisions).

## Resolution

Accepted in [ADR 0042: Two-Portal Screen Inventory](../../../docs/adr/0042-two-portal-screen-inventory.md). The app has sign-in/sign-out, Owner Portal, and Claimant Portal only. Reviewer, executor, administrator, and in-app DBMS Inspector screens are removed; database inspection uses external development/viva tools.
