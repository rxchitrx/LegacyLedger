# 0011: Advisory Stale Asset Warnings via Database Views Over Release-Blocking Triggers

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  Financial holdings in India risk becoming inoperative (2 years of inactivity in bank accounts) or transferred to statutory unclaimed funds (RBI DEA Fund or IEPF after 10 years).
  An asset declaration made years prior to demise may have matured or rolled over.
  However, hard-blocking estate release if an asset is older than an arbitrary threshold would deprive heirs of critical evidence regarding the existence of the deceased's accounts.

- **Decision**:
  1. Stale assets are detected advisory-first via computed logic in relational views (`v_owner_asset_summary` and `v_authorized_claimant_assets`).
  2. If `NOW() - asset.last_verified_at > INTERVAL '365 days'`, the view computes `is_stale = TRUE` alongside calculated elapsed days.
  3. In the Owner Portal, stale assets trigger a prominent reminder banner prompting the owner to re-certify holding active status or upload an updated statement.
  4. Upon estate release, stale assets are NOT blocked from transmission; instead, the generated claimant `checklist_item` notes the aged provenance and appends guidance to request an updated statement/interest certificate or check RBI UDGAM / IEPF if inoperative.

- **Consequences**:
  - **Positive**: Protects family continuity by releasing all discovered evidence; prevents lost inheritance while providing actionable institutional dormancy guidance.
  - **Trade-off**: Requires database views to compute time differences dynamically against current system timestamps.

- **Amendment (ADR 0034)**: The stale-asset age is supplied from project/deployment configuration; the demo value is 365 days. It is not editable in the app.
