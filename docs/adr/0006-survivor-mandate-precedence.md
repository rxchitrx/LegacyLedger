# 0006: Precedence of Survivor Mandates over Nominee Claims in Joint Assets

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  Under Reserve Bank of India (RBI) Master Directions on Deceased Depositors and Indian financial law, an account or deposit with an operational survivorship clause (`EITHER_OR_SURVIVOR`, `ANYONE_OR_SURVIVOR`) grants the surviving account holder the legal right to operate or receive the balance upon the death of one holder.
  Nominees only receive entitlement if all joint account holders have died.
  Generating identical or conflicting post-death claim workflows for both the surviving joint holder and the registered nominee creates legal confusion and violates regulatory guidelines.

- **Decision**:
  1. During the atomic estate release transaction (`sp_execute_atomic_release`), the workflow generation logic branches on `asset.holding_type`.
  2. If `holding_type = 'EITHER_OR_SURVIVOR'` (or joint with operational mandate) and a surviving joint holder exists:
     - The active claim/continuation `workflow` and actionable `checklist_item` rows are assigned to the **Surviving Joint Holder** (streamlined RBI survivor KYC & operational transfer route).
     - Any registered `nomination` for that asset receives status `DEFERRED_TO_SURVIVOR` with explicit, grounded legal text noting that survivor mandate supersedes nominee claims during the lifetime of any joint holder.
  3. If `holding_type = 'SOLE'` or all joint holders are deceased:
     - The claim `workflow` is generated directly for the **Nominee(s)** based on their respective `allocation_percentage`.

- **Consequences**:
  - **Positive**: Strict compliance with RBI banking regulations; prevents erroneous claims filed by nominees against surviving joint holders.
  - **Trade-off**: Requires the stored procedure and relational rules engine to inspect both `ownership` (survivors) and `nomination` records when instantiating workflows.
