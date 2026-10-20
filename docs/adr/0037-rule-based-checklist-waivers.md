# 0037: Rule-Based Checklist Waivers

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  Checklist items can be `PENDING`, `COMPLETED`, or `WAIVED`. A claimant must not be able to bypass a required institution document merely by changing its status.

- **Decision**:
  1. Claimants cannot manually waive checklist items.
  2. A versioned `ProcessRule` may declare an item not applicable under a documented condition. The system may then set that item to `WAIVED` only when the condition is met.
  3. The waiver records the matching rule/source, condition, timestamp, and system actor in the audit trail. If the rule cannot determine that an item is inapplicable, the item stays pending.

- **Consequences**:
  - **Positive**: Mandatory claim requirements cannot be skipped by a user, and rule-based exceptions remain explainable.
  - **Trade-off**: A claimant who believes a rule is wrong cannot override it in the app; the claim rule must first be corrected by a project maintainer.
