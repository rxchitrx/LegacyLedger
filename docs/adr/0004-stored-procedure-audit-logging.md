# 0004: Explicit Stored Procedure Audit Logging for Consequential Operations

- **Status**: Accepted
- **Date**: 2026-10-17
- **Context**:
  The system requires an append-only, tamper-evident audit trail for every consequential operation (asset creation, nominee modification, simulated death verification, access grant, and checklist completion).
  In connection-pooled web backends, database triggers lack direct knowledge of the application's authenticated `actor_id` unless complex session-level configuration variables are injected.
  Additionally, the academic course rubric explicitly grades students on Stored Procedures, parameterized inputs, and ACID transaction control.

- **Decision**:
  1. Consequential operations must be executed via PostgreSQL Stored Procedures (`sp_register_new_asset`, `sp_assign_nominee_to_asset`, `sp_execute_atomic_release`, `sp_complete_checklist_item`).
  2. Each procedure takes an explicit `p_actor_id UUID` parameter.
  3. Inside the procedure's transaction block, the procedure writes directly to `audit_event` alongside the state changes, rolling back everything if any step fails.
  4. Triggers are reserved for data integrity enforcement where actor identity is not the primary driver (e.g., verifying $\sum \text{nominee allocation} \le 100\%$ before insert/update, and preventing updates/deletes to `audit_event` to keep it strictly append-only).

- **Consequences**:
  - **Positive**: Directly satisfies academic requirements for stored procedures; guarantees atomic logging; eliminates fragile session variable workarounds.
  - **Trade-off**: Requires database logic to be maintained in migration/DDL files alongside backend ORM models.
