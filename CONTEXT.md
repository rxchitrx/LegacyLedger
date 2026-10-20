# Domain Glossary (CONTEXT.md)

## System Roles & Identity
- **Person**: A unique individual identified in the system (holds masked PAN/Aadhaar, contact metadata subject to purpose-based retention and erasure rules in ADR 0041).
- **Account**: A seeded login linked to a `Person` and one fixed system role. Demo accounts use unique usernames and passwords; password material stays outside the repository and only salted password hashes are stored in the database (ADR 0029 / 0030).
- **System Role**: The app has two human roles:
  - `OWNER`: Individual who sets up and manages their single estate profile, assets, nominees, and claimant designations during their lifetime.
  - `CLAIMANT`: An owner-designated nominee or legal heir who can access assigned asset information and guided claim workflows only after estate release. The app association does not itself establish legal heirship (ADR 0030).

## Asset Entitlements & Relationships
- **Ownership**: The legal relationship linking a `Person` to an `Asset`.
  - Holding modes: `SOLE`, `EITHER_OR_SURVIVOR`, `JOINTLY`.
- **Nomination**: A statutory arrangement linking a `Person` to an `Asset` specifying an `allocation_percentage` ($\le 100\%$). Under Indian financial law (RBI, SEBI, IRDAI), a nominee acts as a trustee/custodian for legal heirs, not automatically absolute owner.
- **Minor Nominee & Appointee**: Statutory requirement where a nominee under 18 years of age (`is_minor = TRUE`) must have an adult guardian/appointee (`appointee_id`) designated to execute claims on their behalf.
- **Intended Beneficiary**: A person named in a testamentary document (such as a will) as someone intended to receive an asset. LegacyLedger records this as owner-provided information; it does not verify legal validity or determine entitlement (ADR 0045). Distinct from a statutory nominee and a verified legal heir.
- **Legal Heir**: An individual entitled to succeed to the estate under applicable personal succession law (e.g., Hindu Succession Act, Indian Succession Act).

## Estate Release Lifecycle
- **EstateProfile**: The master record of an owner's estate status:
  - Exactly one profile exists per owner and contains all of that owner's declared assets and related estate information. The owner creates it explicitly by choosing **Set up my estate**.
  - `ACTIVE`: Normal operational state. The owner can add/modify assets, documents, nominees, and designated claimants. Claimants have zero access.
  - `PENDING_VERIFICATION`: A claimant submits a death certificate to start a release request. Once basic certificate checks pass, an in-app alert and simulated email and WhatsApp records are created for the Owner as the Veto Window starts. The in-app alert remains visible until opened or acted on; no external messages are sent (ADR 0033). If no veto occurs before the window expires, the system approves the release automatically (ADR 0030).
  - `DISPUTED`: The living owner exercised their veto ("I am alive"), canceling the release event and triggering an immutable security audit alert. A later request can be filed only after an out-of-app resolution; no app administrator clears the estate.
  - `RELEASE_APPROVED`: The veto window elapsed without an owner veto, so the system approved release automatically. An atomic ACID transaction executes:
    1. Status moves to `RELEASE_APPROVED`.
    2. Asset-specific `Workflow` records and `ChecklistItem` rows are generated.
    3. Scoped `Permission` grants are assigned to authorized claimants/nominees.
    4. An `AuditEvent` is recorded.
  - `ARCHIVED`: The system archives the estate after all assigned workflows reach a terminal state (`SETTLED`, `LAPSED`, or `WITHDRAWN`). A disputed or unassigned-succession workflow blocks archival (ADR 0044).
- **Release Request**: A claimant-filed death-claim (`PENDING` → `APPROVED` | `CANCELLED_BY_VETO`). The demo checks that the death certificate is present and readable and that the deceased person's name matches the owner's recorded name; these checks do not authenticate the certificate. An unreadable document or mismatch blocks release until a corrected upload passes, at which point the owner's veto window starts again. If the owner does not veto during that window, the system approves the request automatically (ADR 0032).
- **Estate Release Summary**: Read-only release outcome generated from PostgreSQL release, workflow, permission, and asset-notice records. The owner can see the estate summary; a claimant sees only their assigned assets and related notices (ADR 0040).
- **Veto Window**: The period after a death certificate passes basic checks during which the Owner may veto with "I am alive"; the system waits for it to elapse before automatic approval. A corrected certificate that passes checks starts a fresh window (ADR 0032). The owner receives a persistent in-app alert and simulated email and WhatsApp records; no external messages or retries occur (ADR 0033). The demo window is 2 minutes; timing values live in project/deployment configuration and cannot be changed in the app (ADR 0034).

## Document & Extraction Boundary
- **Document**: The canonical file metadata stored in PostgreSQL (file path, SHA-256 hash, verification status, and shared `extraction_id`). Raw binaries reside in encrypted local storage.
- **Shared Statement**: A document containing co-mingled assets or folios (such as a Consolidated Account Statement / CAS), flagged with `is_shared_statement = TRUE`.
- **Extraction Candidate**: The semi-structured OCR/NLP payload stored exclusively in MongoDB keyed by `extraction_id` (candidate field values, source snippet spans, page coordinates, and confidence scores).
- **Two-Tier Extraction**: The extraction architecture combining an offline local deterministic parser (PyMuPDF + regex pattern matchers) with an optional cloud LLM structuring engine for maximum viva resilience.
- **Human Verification**: The explicit human-in-the-loop review step where an owner confirms or corrects candidate fields, promoting them into typed, constrained PostgreSQL rows (`Asset`, `Ownership`, `Nomination`).
- **Claimant Document Disclosure**: Claimants may view and download full documents linked to their assigned assets. Required documents cannot be blocked by the owner; optional-document access uses an allowed-by-default per-claimant/document flag the owner may change while the estate is active. Preference changes, views, and downloads are audited (ADR 0031 / 0039).
- **Permission Grant**: A PostgreSQL `permission` row created at estate release for a claimant's assigned asset workflow. It permits access only to that asset and workflow; after settlement/closure and estate archiving, the claimant retains read-only access to their history and accessible documents (ADR 0031).
- **Shared Document Access**: A claimant assigned to any asset linked to a shared document may access the full document, including its contents about other assets. The owner may block optional documents, but process-rule-required documents remain viewable and downloadable. Views and downloads are audited (ADR 0031).

## Privacy & Masking (DPDP Compliance)
- **Account Identifier Mask**: The canonical privacy-safe representation of an asset account number, folio, DP ID, or policy number (e.g., `XXXX-XXXX-1234`).
- **Identifier Hash**: A deterministic SHA-256 hash of the normalized identifier combined with the institution identifier, enforcing deduplication via unique constraints without persisting plaintext numbers.

## Claim Guidance & Workflows
- **ProcessRule**: Structured, versioned legal requirements per asset class and institution (e.g., documents required, claim thresholds, forms), each linked to a **GuidanceSource**.
- **GuidanceSource**: Official regulatory circular, master direction, or transmission guidance linked to a ProcessRule, with issuing authority, reference/title, effective date, source URL, and checked date. Project maintainers update seeded rules and contacts outside the app (ADR 0035).
- **Workflow**: An active claim case instantiated for a specific claimant on a specific asset following estate release, carrying a `share_percentage` entitlement. Lifecycle states:
  - `PENDING`: Initial state upon release.
  - `IN_PROGRESS`: Claimant actively working on checklist tasks.
  - `SUBMITTED_TO_INSTITUTION`: Claim packet filed with the bank/RTA/insurer.
  - `SETTLED`: Successful transfer/payout confirmed by claimant.
  - `DISPUTED`: Claimant records an external legal or institutional objection on their own workflow (ADR 0036).
  - `WITHDRAWN`: Terminal state entered when the claimant voluntarily stops their own workflow; no reason is required. If already submitted to an institution, this closes app tracking only (ADR 0038).
- **LAPSED Workflow**: A terminal state automatically assigned by the system after 180 days without claimant or checklist activity for a non-disputed assigned workflow. Disputed and unassigned-succession workflows do not auto-lapse (ADR 0034 / 0044).
- **Claim Lapse**: System closure of an inactive claim workflow after 180 configured days without activity, with an immutable system audit event (ADR 0034 / 0044).
- **Dispute Closure**: The workflow claimant may resume their own disputed workflow with a resolution note or withdraw it without a reason; no executor/admin closure action exists (ADR 0038 / 0044).
- **Checklist Waiver**: Only the system may set an item to `WAIVED`, and only when a versioned ProcessRule establishes that the requirement does not apply; claimant overrides are not allowed (ADR 0037).
- **ChecklistItem**: An individual sequential task or document submission requirement within a `Workflow`, tied to authoritative regulatory guidance (`PENDING`, `COMPLETED`, `WAIVED`).
- **Survivor Precedence**: Regulatory mandate (e.g. RBI `EITHER_OR_SURVIVOR`) prioritizing operational continuation for the surviving joint holder over statutory nominees.
- **Deferred Nomination**: Status of a nominee's entitlement when a surviving joint holder exists, deferring claim rights until all joint holders are deceased.
- **Non-Nominee Succession**: The high-friction statutory claim path triggered when an asset has sole holding and zero nominees, requiring legal heir affidavits, indemnity bonds, NOCs, or succession certificates.
- **Unassigned Succession**: Status assigned to an un-nominated asset — or an unassigned residual share (ADR 0025) — when no claimant has been designated for the relevant claim. It grants no claimant access and blocks estate archiving; there is no post-release reassignment path (ADR 0044).

## Auditability & Integrity
- **AuditEvent**: An immutable, append-only log entry recording every consequential operation (actor, timestamp, event type, target entity, change payload, IP/client info).
- **Append-Only Trigger**: A database trigger on `audit_event` that explicitly blocks `UPDATE` and `DELETE` queries, preventing tampering even from privileged connections.
- **Estate Freeze Trigger**: A database trigger blocking any `UPDATE` or `DELETE` on `Asset`, `Ownership`, or `Nomination` once the estate enters `RELEASE_APPROVED` or `ARCHIVED`.
- **Correction Record**: An assigned claimant may append a reasoned correction for an asset linked to their workflow, with optional evidence. The original row stays unchanged; the claimant-submitted value is labeled unverified and remains within authorized scopes (ADR 0028 / 0044).
- **Allocation Cap Trigger**: A database trigger on `nomination` executing before `INSERT` or `UPDATE` that aborts transactions if the cumulative nominee allocation exceeds 100%.
- **Allocation Completeness**: State reflecting whether total assigned nominee percentages equal exactly 100%, or a confirmed Residual Devolution covers the shortfall, prior to estate release eligibility.
- **Residual Devolution**: The explicit owner confirmation (`residual_devolution_to_legal_heirs`) that the unallocated percentage of an asset devolves upon legal heirs via succession law; at release it generates one `LEGAL_HEIR_FALLBACK` workflow carrying the residual `share_percentage`.
- **Stale Asset**: An asset record whose last verification timestamp exceeds the configured freshness threshold (365 days in the demo), flagged advisory-first in database views without obstructing post-death release (ADR 0034).
- **Recertification**: The owner's explicit confirmation or re-upload of updated statements to refresh an asset's active operational standing.
- **Document Deletion Integrity Trigger**: A database trigger on `document` that automatically demotes parent asset status to `INCOMPLETE_DOCUMENTATION` when all supporting proof is removed.
- **Asset Operational Status**: States governing asset lifecycle:
  - `DRAFT`: Incomplete fields or unconfirmed extraction.
  - `READY`: Verified by owner with active supporting documentation.
  - `INCOMPLETE_DOCUMENTATION`: Previously verified asset stripped of supporting evidence.
  - `REQUIRES_MANUAL_REVIEW`: Asset deferred during estate release due to missing documentation or unlinked rules, while healthy assets proceed.
  - `UNASSIGNED_SUCCESSION`: Un-nominated asset (or residual share) without an owner-designated claimant. It remains inaccessible and prevents archival; assignments must be made before a release request (ADR 0044).
  - `RELEASED`: Under active claim workflow post-estate release.
- **Resilient Release Transaction**: The PostgreSQL stored procedure (`sp_execute_atomic_release`) utilizing database savepoints to release cleared assets to claimants immediately while isolating and deferring problematic assets for manual review.
- **Supplementary Release**: The automatic, trigger-driven generation of claim workflows for an asset deferred at release (`REQUIRES_MANUAL_REVIEW` / `UNASSIGNED_SUCCESSION`) once its missing prerequisites — verified documentation, a matching active `ProcessRule`, or claimant assignment under the still-to-be-decided post-release process — are remediated while the estate is `RELEASE_APPROVED`. Runs entirely inside the database; the only post-release `Asset` mutation the freeze trigger permits.

## Demonstration & Evaluation
- **Persona Swapping**: The viva demonstration pattern where a user signs out of one seeded account and signs into another to exercise `OWNER` or `CLAIMANT` permissions. Claimant access remains scoped to released workflows and permission records (ADR 0029 / 0030).
- **Dataset Grounding**: Use AgamiAI files as synthetic current-account parser/OCR fixtures only; they do not provide real HDFC/SBI/ICICI layouts. Use documented casparser coverage for CAMS/KFintech mutual-fund CAS, NSDL/CDSL demat CAS, and NPS; source institution claim rules independently from official guidance (ADR 0035).
- **Personal-Data Retention**: Retention is purpose-based and class-specific; extraction candidates are deleted after owner review, and personal data is erased when no longer needed unless a documented legal or claim basis requires retention. Audit records avoid raw content and unnecessary personal details (ADR 0041).
- **Coordinated Backup Set**: One timestamped PostgreSQL dump, MongoDB dump, and encrypted-vault snapshot plus manifest; the encryption key is protected separately and must match on restore (ADR 0043).
