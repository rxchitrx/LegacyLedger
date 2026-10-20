# 0007: Fallback Claim Routing to Executor or Legal Heir for Un-Nominated Assets

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  In India, a substantial portion of unclaimed financial assets arises from accounts with no registered nominee and sole holding.
  Under RBI, SEBI, and AMFI regulations, transmission without a nominee requires an alternate, high-friction legal route (Indemnity Bonds, Legal Heir Affidavits, NOC from other legal heirs, or formal Succession Certificates).
  The system must determine who receives access and which workflow checklist is generated when an asset has neither joint holders nor statutory nominees.

- **Decision**:
  1. If an asset has `holding_type = 'SOLE'` and zero records in the `nomination` table upon approved estate release:
     - The atomic release procedure checks for a designated `EXECUTOR` or `LEGAL_HEIR` linked to the `estate_profile`.
     - The claim `workflow` is generated and assigned to that designated representative.
     - The procedure matches the asset against the non-nominee fallback variant in `process_rule`.
     - The generated `checklist_item` rows explicitly mandate intestate/testamentary legal requirements (e.g., Legal Heir Certificate/Affidavit, Indemnity Bond with Sureties, Family NOC).
  2. If no executor or legal heir is registered on the estate profile at all, the asset transitions to `UNASSIGNED_SUCCESSION` and is surfaced in an administrative view (`v_pending_succession_assets`) requiring manual designation.
  3. The same fallback route and view also handle unassigned residual shares of under-allocated nominations (ADR 0025): the residue, not the whole asset, enters the non-nominee path.

- **Consequences**:
  - **Positive**: Accurately reflects Indian legal reality; demonstrates the system's ability to model both nominee claims and complex intestate succession claims.
  - **Trade-off**: Requires pre-seeding non-nominee regulatory rule sets alongside standard nominee transmission rules.

- **Amendment (ADR 0044)**: Fallback workflows route only to owner-designated claimant identities. No executor/admin account or post-release reassignment path exists. An unassigned succession workflow remains inaccessible and blocks archival.
