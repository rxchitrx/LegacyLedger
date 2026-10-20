# 0044: Two-Role Post-Release Lifecycle

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  Older lifecycle decisions assign claim lapse, dispute closure, estate archiving, supplementary asset assignment, corrections, and rule maintenance to executors or administrators. The app now has only owner and claimant roles, and claimant grants are scoped to assigned workflows (ADR 0030 / 0031).

- **Decision**:
  1. **Claim lapse:** The system moves a workflow in `PENDING`, `IN_PROGRESS`, or `SUBMITTED_TO_INSTITUTION` to `LAPSED` after 180 days without claimant or checklist activity. It records `lapse_reason = 'No activity for 180 days'` and writes an immutable audit event with system actor. This closes only the app workflow and does not cancel a filing with an institution. `DISPUTED` and unassigned-succession workflows are excluded from automatic lapse.
  2. **Disputes:** Only the workflow's claimant may exit their own `DISPUTED` workflow: `RESUMED` returns it to `IN_PROGRESS` with a resolution note; `WITHDRAWN` closes it under ADR 0038 without requiring a reason. No executor closure path exists.
  3. **Withdrawal:** A claimant may withdraw their own non-terminal workflow under ADR 0038. If it was submitted externally, this closes only in-app tracking.
  4. **Archiving:** The system archives the estate automatically after every assigned workflow is terminal (`SETTLED`, `LAPSED`, or `WITHDRAWN`) and writes an immutable system audit event. Archiving closes only the app ledger; it does not close external institutional proceedings. A disputed or unassigned-succession workflow blocks archiving until it is resolved. No human attestation screen exists.
  5. **Unassigned succession:** Owner-designated claimants and asset assignments must be set before a release request locks them. After release, the system never grants a claimant access to an unassigned asset on its own. If no claimant was designated before release, the workflow remains inaccessible and blocks archiving indefinitely; there is no post-release reassignment or access bypass in the app.
  6. **Corrections:** A claimant may append a reasoned correction for an asset linked to their own workflow, with optional supporting evidence. The original released value remains unchanged. The correction is displayed as claimant-submitted and unverified; it does not silently become a verified canonical asset value. The event is immutable and visible only within authorized scopes.
  7. **Claim rules and remaining operational maintenance:** Project maintainers update versioned `ProcessRule` and `GuidanceSource` seed data outside the app (ADR 0035). Owners and claimants cannot edit rules.
  8. All post-release actions stay limited to the claimant's own assigned workflows; no executor, administrator, reviewer, or other app account is introduced.

- **Consequences**:
  - **Positive**: Every post-release action has an actor or system rule consistent with the two-role product, and the system never grants access to unassigned assets by default.
  - **Trade-off**: An unresolved dispute or unassigned-succession workflow can keep an estate from archiving; the app has no staff role to force closure or reassignment.
