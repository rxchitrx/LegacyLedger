# 0040: Claimant-Scoped Estate Release Summary

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  The resilient release transaction can defer individual assets while releasing healthy ones (ADR 0013). The result needs a readable summary, but a claimant must not see unrelated estate assets or another claimant's work.

- **Decision**:
  1. Render the release summary as a read-only page in the portals, generated from PostgreSQL release, workflow, permission, and asset-level notice records. Do not store a second, duplicate estate snapshot.
  2. The owner may see the full estate summary. Each claimant sees only the assets and notices attached to their own assigned workflows.
  3. Show whether each visible asset was released to a workflow or deferred, with the relevant reason and next step. Do not reveal unassigned or other claimants' assets in the claimant view.

- **Consequences**:
  - **Positive**: Users can understand partial release outcomes while claimant visibility remains scoped.
  - **Trade-off**: The summary depends on release notices being stored as structured, asset-linked records.
