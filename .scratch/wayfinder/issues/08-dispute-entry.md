# 08: Who can mark a claim as disputed, and how

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

Who can move a claim workflow into `DISPUTED`, and by what action?

Undecided: the authority (claimant, executor, admin, or institution) and the named procedure — the exit exists (`sp_close_dispute`, ADR 0024), but the entry has no decision.

**Relevant refs:** ADR 0009 ("Claimant or institution flags conflicting claims or documentation objections"), ADR 0021 (escalation guidance on dispute).

## Resolution

Accepted in [ADR 0036: Claimant-Initiated Disputes](../../../docs/adr/0036-claimant-initiated-disputes.md). A claimant may mark only their own active workflow as disputed after an external institutional/legal objection, provide a short description, and have the system record an immutable audit event. Existing scoped document access remains.
