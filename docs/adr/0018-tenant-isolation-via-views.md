# 0018: Foreign Key Tenant Isolation and Authorization Views Over Native RLS

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  The system must isolate estates between different users during life, and restrict claimants to only authorized assets post-release.
  PostgreSQL Row-Level Security (RLS) offers database-level filtering, but requires transaction-local session state (`SET LOCAL app.current_user_id`) on every connection from the application pool, adding complexity and fragile failure modes during academic evaluations.

- **Decision**:
  1. Multi-estate isolation is enforced using explicit foreign key scoping (`estate_id`, `owner_id`) across all queries and stored procedures.
  2. Post-release claimant authorization is enforced via dedicated SQL views (e.g., `v_authorized_claimant_assets`) that join the `permission` table against `asset` and `workflow`.
  3. Stored procedures accept explicit `p_actor_id` parameters to validate authorization before executing consequential estate operations.

- **Consequences**:
  - **Positive**: 100% predictable behavior across connection pools, pgAdmin, Streamlit, and automated tests; straightforward debugging without session-variable state leaks.
  - **Trade-off**: Developers must ensure queries consistently include tenant/estate filters in the service layer or route through authorized views.

- **Amendment (ADR 0031)**: The release transaction creates claimant grants per assigned asset workflow. Grants remain available as read-only history after workflow closure and estate archiving.
