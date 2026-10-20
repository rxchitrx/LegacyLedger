# 09: Who can waive a checklist item

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

Who can waive a checklist item instead of completing it, and under what conditions?

Undecided: the authority, required evidence or reason, and audit.

**Relevant refs:** CONTEXT.md ChecklistItem states (`PENDING`, `COMPLETED`, `WAIVED`); ADR 0004 names only `sp_complete_checklist_item`.

## Resolution

Accepted in [ADR 0037: Rule-Based Checklist Waivers](../../../docs/adr/0037-rule-based-checklist-waivers.md). Claimants cannot manually waive an item. The system may mark it waived only when a versioned process rule says it does not apply and records the rule, condition, timestamp, and system actor.
