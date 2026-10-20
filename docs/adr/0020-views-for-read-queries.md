# 0020: Relational Views for Read-Model Queries and Dashboard Aggregations

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  The application dashboard requires fast, clean access to aggregated claim tasks, institution nodal contacts, and document requirements for authenticated claimants.
  We must decide whether read queries should execute through stored procedure functions (`RETURNS TABLE`) or standard relational views.

- **Decision**:
  1. All analytical and dashboard read operations are handled through dedicated PostgreSQL views:
     - `v_pending_claim_tasks`: Exposes joined checklist items, workflow status, asset metadata, and institutional contact points.
     - `v_owner_asset_summary`: Aggregates active assets, classes, documents, and nomination completion status.
     - `v_authorized_claimant_assets`: Filters estate assets through active permissions.
     - `v_audit_activity_report`: Provides human-readable audit event summaries.
  2. Stored procedures are reserved strictly for write-side state mutations, transaction control, and trigger operations.

- **Consequences**:
  - **Positive**: Directly showcases the four views mandated by the course syllabus; provides clean, index-accelerated `SELECT` queries for the application layer.
  - **Trade-off**: Requires the view definitions to encapsulate all join logic and authorization filtering.
