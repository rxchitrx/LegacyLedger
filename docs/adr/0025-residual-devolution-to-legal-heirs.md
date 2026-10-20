# 0025: Residual Devolution of Under-Allocated Nominations to Legal Heirs

- **Status**: Superseded in part by ADR 0044
- **Date**: 2026-10-18
- **Context**:
  ADR 0010 permits nominee allocation sums below 100% during drafting but blocks release approval until "full allocation or explicit sole remainder disposition is confirmed" — a remainderman mechanism that was never defined.
  Under RBI/SEBI/IRDAI practice, a nominee can hold less than the whole asset; the unallocated residue does not evaporate. It devolves upon legal heirs through the statutory non-nominee path (ADR 0007), while nominees receive only their allocated share.
  Without an explicit model, three incorrect behaviors become possible: blocking release forever on a legitimate partial allocation, silently ignoring the residue, or wrongly treating the residue as belonging to the nominees.

- **Decision**:
  1. `asset.residual_devolution_to_legal_heirs BOOLEAN NOT NULL DEFAULT FALSE` is the explicit owner-confirmation flag, set or cleared only by the owner via `sp_confirm_residual_devolution(p_actor_id, p_asset_id, p_confirm)`.
  2. Release eligibility for an asset with nominations: a full 100% allocation is eligible directly; a partial allocation (`0 < Σ < 100%`) is eligible only when the residual flag is TRUE. The check runs inside `sp_execute_atomic_release`; an ineligible asset takes the per-asset savepoint deferral (ADR 0013) and lands in `REQUIRES_MANUAL_REVIEW`.
  3. At release, each nominee (or minor's appointee) receives a workflow whose `share_percentage` equals their allocation. When the residual share (`100% − Σ allocations`) is greater than zero, ONE additional workflow is generated with route `LEGAL_HEIR_FALLBACK` and `share_percentage = residual`, carrying the non-nominee checklist (Legal Heir Certificate/Affidavit, Indemnity Bond, NOC).
  4. The residual fallback workflow is assigned to the estate's registered executor or legal heir. If none is registered at release time, it is created with `claimant_person_id = NULL` as an unassigned succession case, surfaced in `v_pending_succession_assets` for manual designation (ADR 0007); the nominee workflows proceed unaffected.
  5. `workflow.share_percentage` records the entitlement on every generated workflow (100% for sole nominee, survivor-continuation, or whole-asset fallback cases).
  6. Unassigned residual workflows are active workflows: they block archiving (ADR 0022) until designated and closed through the normal resume/lapse paths.

- **Consequences**:
  - **Positive**: Faithful modeling of Indian succession practice; nominee claims release immediately without being blocked by the residue; the owner explicitly acknowledges the succession path, which is easy to demonstrate against the allocation trigger in the viva.
  - **Trade-off**: Adds an eligibility branch to the release procedure and a nullable-claimant workflow class that views, lapse logic, and archiving must all tolerate.

- **Amendment (ADR 0044)**: Residual workflows may route only to an owner-designated claimant. If no claimant is designated before assignments lock, the workflow remains unassigned and inaccessible; there is no post-release executor/admin reassignment path, and the workflow blocks archival.
