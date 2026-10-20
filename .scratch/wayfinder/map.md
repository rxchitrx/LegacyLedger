# The wayfinder map: finish the LegacyLedger design

**Label:** wayfinder:map
**Status:** complete

## Destination

Every remaining open design question is answered and recorded as an ADR (plus CONTEXT.md glossary updates): the design is fully closed — nothing left to decide before building starts. This map produces decisions only — no build sequencing, no code.

## Notes

- Domain: LegacyLedger — India-focused digital estate continuity and claim-workflow system (DBMS course project). PostgreSQL + MongoDB, Streamlit UI, stored procedures/triggers/views, DPDP privacy. Glossary: `CONTEXT.md` at repo root.
- Record each resolution as: (1) a new ADR under `docs/adr/` (next free number), (2) CONTEXT.md term updates when names change, (3) a `## Resolution` section in the ticket + close it, (4) one line in this map's Decisions so far.
- House style: ADRs follow the `docs/adr/0027` / `0028` format (Status / Date / Context / Decision / Consequences). Amend older ADRs to cross-reference when a decision supersedes part of one.
- Ask the user questions in plain, simple language.
- Sessions should consult the `wayfinder` skill. The `grilling` / `domain-modeling` skills are not installed — emulate them (ask the user directly, via the question tool or plain text).
- Local-markdown tracker operations (this repo has no ticket tool):
  - The map is this file. Tickets are one file each in `issues/`, carrying Label / Parent / Status / Claimed by / Blocked by.
  - Ticket numbers follow the confirmed fan order, not dependency order; the "Blocked by" line is the only dependency signal.
  - Frontier query: tickets with `Status: open`, no `Claimed by`, and every ticket named in `Blocked by` closed.
  - Claim a ticket by setting `**Claimed by:** <name>` before any work.
  - Close a ticket by setting `**Status:** closed`, appending a `## Resolution` section, and appending one line to Decisions so far here.
  - Research findings live in `research/<name>.md`, pointed at from the ticket and from here.
- Work rhythm: never resolve more than one ticket per session, except research.

## Decisions so far

<!-- one line per closed ticket: [title](link): gist of the answer -->
- [16: Research — DPDP obligations](issues/16-research-dpdp-obligations.md): duties (incl. erasure) phase in ~13 May 2027; erasure yields to retention "necessary for compliance with law"; s.17(1)(a) legal-rights exemption; s.38 preserves sectoral retention laws.
- [17: Research — dataset coverage](issues/17-research-dataset-coverage.md): the real bank dataset is synthetic (no HDFC/SBI/ICICI layouts); casparser covers CAMS/KFintech CAS + NSDL/CDSL demat, nominee names only; "CRS Form 6" = the death certificate.
- [Accounts and sign-in for every persona](issues/01-accounts-and-sign-in.md): seeded `OWNER` and `CLAIMANT` accounts use password sign-in; persona changes require sign-out and sign-in.
- [Estate setup and how people are attached](issues/02-estate-setup-and-designations.md): one owner-created estate profile; owner-designated claimants gain scoped access after automatic release approval.
- [What permission grants actually allow](issues/03-permission-grants.md): grants are created per assigned workflow at release; shared required documents stay available, with read-only history retained after closure and archiving.
- [Automatic release checks after a claimant files a death certificate](issues/04-release-review-criteria.md): demo checks document presence/readability and owner-name match; failed checks hold release until a corrected upload passes, then the veto window restarts; no official authenticity verification.
- [How the owner actually receives the veto-window alert](issues/05-veto-window-notification.md): show a persistent in-app alert and simulated email and WhatsApp delivery records; send no external messages or retries.
- [Where the timing settings live](issues/06-timing-settings.md): keep global timings in project/deployment configuration only; demo values are a 2-minute veto window, 180-day claim inactivity, and 365-day stale-asset warning threshold.
- [07: Seed content — institutions, asset classes, claim rules](issues/07-seed-content.md): source-backed initial rules for bank deposits/FDs, mutual funds, demat equities/bonds, and NPS; maintain versioned rule data outside the app ([coverage research](research/dataset-coverage.md)).
- [08: Who can mark a claim as disputed, and how](issues/08-dispute-entry.md): claimants can dispute only their own workflows and record an external objection.
- [09: Who can waive a checklist item](issues/09-checklist-waiving.md): only the system can waive an item when its versioned process rule says it does not apply.
- [10: Can a claimant withdraw their own claim](issues/10-claimant-self-withdrawal.md): claimants may withdraw their own non-terminal workflow without a reason; external filings remain unaffected.
- [11: Document download consent — record or flag](issues/11-document-download-consent.md): optional document access is an allowed-by-default per-claimant/document flag; owner changes and document access are audited.
- [12: Define the estate release summary](issues/12-estate-release-summary.md): render a relational read-only summary; show claimants only their assigned assets and notices.
- [13: DPDP — retention and erasure vs permanent records](issues/13-dpdp-retention-and-erasure.md): retain personal data by purpose/legal basis, delete reviewed extraction candidates, and keep audit events free of unnecessary personal details ([obligations research](research/dpdp-obligations.md)).
- [14: Full screen inventory](issues/14-screen-inventory.md): provide sign-in and the Owner and Claimant portals only; inspect databases outside the app.
- [15: Backups, restore, and deployment shape](issues/15-backups-and-deployment.md): local Docker Compose demo and coordinated PostgreSQL/MongoDB/encrypted-vault backups with a separately protected key.
- [18: Reassigning estate administration duties without staff roles](issues/18-reassigning-estate-administration-duties.md): system handles eligible lapse/archive transitions; claimants handle only their own claims; unresolved unassigned succession blocks archive; rule maintenance stays outside the app.
- [19: Testamentary documents and intended beneficiaries](issues/19-testamentary-documents.md): wills can be stored and linked to relevant assets as evidence; the app does not interpret legal validity or allocate assets from them (ADR 0045).

## Not yet specified

<!-- in-scope fog: can't be ticketed sharply yet; graduates as the frontier advances -->
- None.

## Out of scope

<!-- ruled beyond the destination; closed, never graduates -->
- Nothing ruled out yet.
