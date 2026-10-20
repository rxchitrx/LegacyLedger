# 18: Reassigning estate administration duties without staff roles

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

How should LegacyLedger handle post-release duties that existing decisions assign to an executor or admin, given that only the owner and claimants use the app?

Decide who can lapse or close a workflow, close a dispute, archive an estate, make post-release corrections, and maintain claim rules. For each duty, decide whether it belongs to a claimant, the system, or an out-of-app operator.

**Relevant refs:** ADRs 0003, 0004, 0022–0028, and 0030.

## Resolution

Accepted in [ADR 0044: Two-Role Post-Release Lifecycle](../../../docs/adr/0044-two-role-post-release-lifecycle.md). The system lapses eligible non-disputed workflows after 180 days of inactivity and archives an estate once all assigned workflows are terminal. Claimants can manage only their own disputes, withdrawals, and reasoned correction records. Unassigned-succession workflows remain inaccessible and block archival; project maintainers update rules outside the app. No executor/admin role is added.
