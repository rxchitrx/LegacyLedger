# 02: Estate setup and how people are attached

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

How is an estate profile created, and how do an executor and legal heirs get attached to it — by whom, with what proof, and with what multiplicity?

**Relevant refs:** ADR 0007 (manual designation surfaced in `v_pending_succession_assets`), ADR 0022 (executor authority over archiving), ADR 0025 / 0026 (a registered executor/legal heir clears `UNASSIGNED_SUCCESSION`).

## Resolution

Accepted in [ADR 0030: Owner-Controlled Estate Setup and Claimant Access](../../../docs/adr/0030-owner-controlled-estate-and-claimant-access.md). Each owner has one estate profile, created when they explicitly choose **Set up my estate**. The owner adds multiple claimant identities; claimants may be nominees or legal heirs and receive scoped app access only after release. Owner designation is enough for app access; institution-required legal evidence remains on the claim checklist. A claimant can submit the death certificate; the system approves release automatically after the veto window if the owner does not veto.
