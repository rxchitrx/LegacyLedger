# 12: Define the estate release summary

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

What is the "estate release summary" that the release transaction writes explanatory notices into — a view, a report, or a UI page — and who sees it?

Undecided: the artifact's form, storage, and audience.

**Relevant refs:** ADR 0013 ("an explanatory notice is added to the estate release summary").

## Resolution

Accepted in [ADR 0040: Claimant-Scoped Estate Release Summary](../../../docs/adr/0040-claimant-scoped-release-summary.md). Render a read-only summary from relational release/workflow/permission/notice records. The owner sees the full estate summary; claimants see only their assigned assets and related notices.
