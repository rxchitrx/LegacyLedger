# 0009: Claimant-Driven Workflow Lifecycle and Progress Tracking

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  LegacyLedger is an information organization and claim guidance system, not an automated payment gateway, clearinghouse, or court adjudication platform.
  The ultimate transmission of funds and physical transfer of securities takes place offline or through institutional portals (banks, RTAs, DPs, insurers).
  We must define how workflow states and checklist progress are updated once an estate is released.

- **Decision**:
  1. The progress of individual `checklist_item` tasks is driven by the authorized claimant (`PENDING` -> `COMPLETED`, with optional input of external institutional reference numbers e.g., bank acknowledgement slip ID).
  2. The overarching `workflow` status follows a deterministic lifecycle:
     - `PENDING`: Initial state upon estate release before any claimant action.
     - `IN_PROGRESS`: Claimant has begun interacting with or completing checklist tasks.
     - `SUBMITTED_TO_INSTITUTION`: Claimant has submitted physical/digital packets to the institution/registrar.
     - `SETTLED`: Claimant confirms institutional settlement (balance credited / folio transferred).
     - `DISPUTED`: Claimant or institution flags conflicting claims or documentation objections.
  3. The `Executor` possesses read-only supervisory visibility over all estate workflows to track overall estate settlement progress without overriding claimant checklist actions.
  4. Every task completion or workflow status transition writes an immutable record to `audit_event`.

- **Consequences**:
  - **Positive**: Accurately reflects the system's role as a guidance and continuity ledger; avoids untenable architectural dependencies on real-time external banking settlement APIs.
  - **Trade-off**: Relies on claimant self-reporting for final settlement confirmation in the software.

- **Amendment (ADR 0038 / 0044)**: `WITHDRAWN` is a terminal state a claimant may apply to their own non-terminal workflow without a reason. The system automatically lapses eligible assigned workflows after 180 days of inactivity; disputes are handled only by their claimant.
