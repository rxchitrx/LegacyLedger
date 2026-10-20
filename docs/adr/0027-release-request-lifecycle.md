# 0027: Release Request Lifecycle with Veto Window and Retry Gates

- **Status**: Superseded in part by ADR 0030
- **Date**: 2026-10-18
- **Context**:
  The release flow started at `PENDING_VERIFICATION` but lacked three rules: how long the owner's warning window lasts and whether the reviewer must wait it out; what happens after a reviewer rejects a certificate; and what happens after the owner vetoes with "I am alive".
  Without a mandatory wait, a forged certificate could be approved before the owner ever sees the alert. Without retry gates, a rejected executor could refile endlessly, and a living owner's veto could simply be ignored by refiling.

- **Decision**:
  1. Filing a release creates a `release_request` row (`status = 'PENDING'`) and moves the estate to `PENDING_VERIFICATION`. The request records the death certificate document and the filing executor.
  2. The **veto window** is a configurable duration (shortened for the demo). The reviewer decides via `sp_decide_release_request(p_actor_id, p_release_request_id, p_decision, p_reason)`:
     - `APPROVE` aborts unless the veto window has fully elapsed with no veto;
     - `REJECT` may happen at any time and requires a reason.
  3. Owner veto via `sp_owner_veto_release(p_actor_id, p_release_request_id, p_reason)`: the request becomes `CANCELLED_BY_VETO`, the estate becomes `DISPUTED`, and an immutable security alert event is written.
  4. Reviewer rejection: the request becomes `REJECTED`, the estate returns to `ACTIVE`, and the certificate document is flagged rejected. The executor may file again only with a **new** death certificate document; the rejected one can never be resubmitted.
  5. After a veto, no new release request can be filed while the estate is `DISPUTED`. An `ADMIN` must first clear the estate via `sp_admin_reopen_estate(p_actor_id, p_estate_id, p_reason)`, returning it to `ACTIVE` with an audit event.
  6. Every filing, decision, veto, rejection, and admin clearance writes an immutable audit event.

- **Consequences**:
  - **Positive**: The owner always gets a full warning window before any approval; rejected certificates face a hard evidence gate; votes-of-no-confidence against a living owner require admin intervention; the `ADMIN` role gains a concrete, demonstrable responsibility.
  - **Trade-off**: A genuine death takes at least one veto window longer to release, so the demo configuration must use a short window for practical pacing.

- **Amendment (ADR 0030 / 0032)**: A claimant files the request and the system approves automatically after the veto window if the owner does not veto. The executor filing and reviewer approval/rejection steps above are superseded. The demo's basic certificate checks are defined in ADR 0032.
- **Amendment (ADR 0032)**: The demo checks certificate presence/readability and owner-name match only. An unreadable document or mismatch blocks release until a corrected upload passes; the veto window then starts again. These checks do not authenticate the certificate.
- **Amendment (ADR 0034)**: The veto-window duration is stored in project/deployment configuration, outside the app UI; its demo value is 2 minutes.
