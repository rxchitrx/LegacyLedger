# 10: Can a claimant withdraw their own claim

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

Can a claimant withdraw their own claim entirely, or must they wait for the executor to close it?

If self-withdrawal is allowed: which states, what reason, what audit, and does it differ from lapse?

**Relevant refs:** ADR 0024 ("A claimant who wishes to withdraw a disputed claim entirely must rely on the executor closing it; claimant self-withdrawal is not modeled.").

## Resolution

Accepted in [ADR 0038: Claimant Workflow Withdrawal](../../../docs/adr/0038-claimant-workflow-withdrawal.md). A claimant may withdraw their own non-terminal workflow without giving a reason. The system records the actor and time; an optional note is allowed. If the case was filed with an institution, withdrawal ends only the app tracking.
