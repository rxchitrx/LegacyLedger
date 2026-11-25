# LegacyLedger Technical Architecture Plan

**Status:** Proposed plan for review  
**Product form:** Browser-based web application; no native mobile or desktop application is planned.  
**Initial deployment:** Local Docker Compose demo per ADR 0043; no hosted URL is needed for the current scope.  
**Scope:** This is an implementation plan, not a production security certification.

## 1. Goal

Build the approved Owner and Claimant workflows as a browser-accessed web application. For the initial demo, run the web server and its data services locally with Docker Compose. Keep authoritative estate and claim state relational, preserve the required MongoDB extraction-candidate boundary, and store uploaded files encrypted outside both databases.

The repository currently contains design records but no application source code. This plan provides a buildable component structure without claiming that any of it is implemented.

The complete logical ER model is presented as a readable set of nine Chen-notation sheets. See the [ER model index](diagrams/README.md) for editable Excalidraw files and PNG/SVG previews. It reflects accepted product decisions but is not a migration-ready physical schema.

## 2. Recommended stack

| Area | Recommendation | Basis |
|---|---|---|
| Language | Python 3.11+ for backend and document processing; TypeScript for the React frontend | Submitted requirements plus working frontend choice |
| Web UI | React browser frontend, with sign-in plus Owner and Claimant portals | User prioritized visual quality, responsiveness, and flexibility; submitted requirements list React |
| Web API | One modular FastAPI backend; it coordinates PostgreSQL, MongoDB, and the encrypted vault, sequentially or concurrently depending on the operation | User approved recommendation; work is coordinated in one backend, not assumed to run in parallel |
| Browser authentication | Secure, HTTP-only session cookie; validate the authenticated identity server-side for every protected operation | User approved |
| Relational store | PostgreSQL | 3NF estate data, integrity rules, views, procedures, and transactions |
| PostgreSQL vector search | pgvector indexes chunks of approved, versioned official guidance for retrieval and cited claimant Q&A; it does not generate or alter deterministic checklist rules | User approved this use |
| PostgreSQL cryptographic functions | pgcrypto creates keyed HMAC-SHA-256 fingerprints for exact identifier deduplication only; the stable key is kept in a protected local secrets file, excluded from Git and stored separately from database backups | User approved |
| Relational access | SQLAlchemy for connections and ordinary reads; versioned SQL migrations for schema, views, procedures, and triggers | ADR 0003 / 0004 / 0020; Alembic is the proposed migration tool |
| MongoDB | Temporary extraction candidates plus durable history of uploaded file versions only | User chose to retain uploads, not extraction/review revisions; extraction can be rerun from a retained file version |
| Input validation | Pydantic models at API/service boundaries | Submitted requirements and Python backend |
| File storage | Local filesystem vault; FastAPI encrypts every uploaded version with AES-256-GCM before writing it and verifies integrity on read | User approved |
| Local demo secrets | Generate the vault key and store it in a local secrets file excluded from Git; back it up separately from the database and encrypted vault files. Hosted key management remains a later decision. | User approved for now |
| Local runtime | Docker Compose on the developer's computer, with the web app, PostgreSQL, MongoDB, and a separate background worker service; persistent volumes for data | User approved local Compose worker setup |
| Tests | pytest, with PostgreSQL integration tests and focused service/UI workflow tests | Proposed implementation choice; academic DB behavior needs real PostgreSQL verification |
| Document extraction | Local PDF text extraction and OCR always run first. Gemini `gemini-3.8-flash` is an optional fallback when local extraction cannot produce usable results; the Owner can review local results if Gemini is unavailable. The API key will be supplied later and loaded from runtime secrets, never committed. The demo uses synthetic documents only. | User confirmed local-first and fallback behavior; model selected, key deferred |

This is a browser-based web application: React renders the interface and calls one modular FastAPI backend. The backend owns authorization, validation, and business operations; it calls each store as needed. No native mobile or desktop client is included.

## 3. Component shape

```text
Owner / Claimant browser
          |
          v
React pages and browser session handling
          |
          v
FastAPI API and application services (use cases, authorization, validation)
       /       |          \
      v        v           v
PostgreSQL  MongoDB    Encrypted file vault
truth       extraction  original uploads
            candidates
```

Suggested source layout:

```text
web/                           React frontend source
api/                           FastAPI routes and application entry point
legacyledger/
  auth/                        account lookup, password verification, secure HTTP-only session cookie and session identity
  services/                    estate, asset, release, claim, document, extraction use cases
  db/postgres/                 SQLAlchemy connection, repositories, procedure calls
  db/mongo/                    candidate repository and Mongo setup
  storage/                     encrypted vault read/write and file lifecycle
  extraction/                  PDF text, OCR, deterministic parsing, optional LLM adapter
  schemas/                     Pydantic input/output models
  config.py                    environment and project timing settings
db/migrations/                 ordered SQL schema, views, procedures, and triggers
seed/                          demo accounts, process rules, and synthetic fixtures
tests/                         unit and PostgreSQL/Mongo integration tests
```

Keep browser components focused on rendering and interaction. They must not contain direct database access, file encryption, or authoritative authorization rules.

## 4. Data and responsibility boundaries

- **PostgreSQL is authoritative** for accounts/people, estate profiles, assets, ownership, nominations, document metadata, claimant assignments, release requests, workflows, checklists, permissions, notices, process rules, and audit events.
- **pgvector is a retrieval aid** over approved official guidance chunks. Retrieval returns source-linked passages for claimant Q&A; PostgreSQL `ProcessRule` records remain the authority for workflow checklists.
- **MongoDB holds unverified extraction candidates and durable history records for uploaded file versions.** Candidate values are keyed by `extraction_id`; they never become asset facts until an Owner reviews and confirms them. Do not retain successive extraction/review drafts; rerun extraction from a retained file version when needed.
- **The encrypted vault holds the actual bytes for every uploaded file version.** FastAPI uses AES-256-GCM with a fresh unique nonce for each encryption and verifies integrity when reading. PostgreSQL remains authoritative for the current document record, asset links, permissions, and audit trail. MongoDB stores a durable version record per upload, including a stable version ID and vault reference. Avoid exposing raw filesystem paths to the UI.
- **Cross-store workflows are coordinated by application services.** PostgreSQL, MongoDB, and the filesystem cannot share one ACID transaction. Use ordered writes, idempotent operations, compensating cleanup, and a small retryable cleanup queue for orphaned files/candidates. The canonical ownership and workflow state always remains in PostgreSQL.

### Upload and extraction flow

1. Validate size and allowed file type; calculate SHA-256.
2. Encrypt and write the original to the vault under an opaque identifier.
3. Insert document metadata and `extraction_id` in PostgreSQL. If this fails, remove the just-written vault file.
4. Always run local extraction first with PyMuPDF and Tesseract for scanned pages. If local extraction cannot produce usable results and Gemini is enabled/configured, call Google Gemini API model `gemini-3.8-flash` as a fallback for synthetic demo documents only. If Gemini is unavailable, keep the local results available for Owner review and show that the fallback did not run. No real personal or financial documents are used in the demo.
5. Save candidate values, source spans/coordinates, confidence, and engine metadata in MongoDB.
6. Show candidate and source evidence to the Owner. On confirmation, call a PostgreSQL transaction/procedure to create or update typed estate rows and link documents.
7. Delete reviewed candidate data according to ADR 0041; failed deletion is retried and logged without copying candidate PII into logs.

### Release and claimant access

1. The Claimant submits the death-certificate file through a service that runs the agreed presence/readability/name checks.
2. PostgreSQL records the request/check result. A passing check starts the configured veto window and creates in-app plus simulated email/WhatsApp delivery records.
3. The Owner may veto during the window. Otherwise, a scheduler/worker checks expiry and calls the release procedure.
4. `sp_execute_atomic_release` performs asset-level savepoints, creates eligible workflows/checklists/permissions/notices, writes audit events, and defers problematic assets as specified by ADRs 0013, 0030, 0032, and 0040.
5. Claimant reads go through authorized PostgreSQL views and service checks scoped to the authenticated actor. Required documents remain viewable/downloadable; optional document settings follow ADR 0039. Every view/download is audited.
6. Claimant workflow actions and system lapse/archive transitions use PostgreSQL procedures or tightly scoped transactions, with explicit actor IDs and audit writes.

### Release and audit fields for the logical schema

- **Release request:** Retain the request, estate, claimant, and current certificate references and the existing status. Add the latest basic certificate check outcome, `veto_started_at`, and `veto_deadline_at`. A failed check leaves the request pending with no active window. When a certificate submission passes the checks, save the start and deadline together using the configured duration (two minutes for the demo), and create the three notification records in the same transaction. A corrected submission that passes receives a full fresh window. Changing the configured duration affects future windows.
- **Veto and automatic approval:** A pending request can be vetoed by its estate owner only before the stored deadline. The worker can approve at or after the deadline only if the request is still pending and its current certificate passed. Both transitions lock the same request row and recheck their conditions before changing status. Keep prior certificate check outcomes, vetoes, and approvals in the audit trail. The request holds the current state used by the worker.
- **Audit event:** Retain `event_id` and explicitly record `action`, `occurred_at`, a pseudonymous `actor_ref` for a human action, and `target_type` plus `target_ref`. Use a null actor reference for system actions. Store only the event details needed for the audit, such as a certificate check outcome, without copying names or certificate content. Write events alongside the corresponding state changes in the same PostgreSQL transaction. The audit trail is append-only and the actor identity mapping is kept separately (ADR 0004 / 0026 / 0032 / 0041).

## 5. Security and privacy boundaries

- Hash seeded account passwords with a modern password-hashing function; never commit plaintext passwords, production secrets, or vault keys.
- For the local demo, store account passwords, the generated vault encryption key, and any optional LLM API key in a local secrets file excluded from Git. Back up the vault key separately from the database and encrypted vault files. Seed demo credentials also belong in ignored local secrets or documented secret injection, not committed plaintext. Revisit managed key storage and recovery before any hosted deployment.
- Keep authenticated actor identity in a server-validated session using a secure, HTTP-only cookie; clear it on sign-out, and validate it again for every protected operation. UI hiding is not authorization.
- Use explicit estate/actor filters and the authorized claimant views. Pass `p_actor_id` to consequential database procedures; do not rely on client-provided role or person IDs without checking the logged-in account mapping.
- Encrypt files using authenticated encryption (recommend AES-256-GCM); use an opaque vault ID, safe file permissions, and a key loaded at runtime. Bind ciphertext to document metadata as authenticated context where supported.
- Do not log raw documents, PAN/Aadhaar, account identifiers, candidate text, or secrets. Keep audit payloads minimal and purpose-bound under ADR 0041.
- Treat a will and its intended-beneficiary links as owner-provided evidence only. The application does not judge validity or distribute assets based on it (ADR 0045).

## 6. Background work and timing

The local Compose setup needs a small worker process (or a single-process scheduler while the demo is running) for veto-window expiry, retryable cleanup, inactivity lapse, and estate archive checks. Keep state transitions in PostgreSQL procedures; the scheduler only finds due work and invokes them idempotently. Read timing values from project/deployment configuration (ADR 0034), never from editable app controls.

For the local demo, run a separate Python worker service in Compose on the same computer as the web app and databases, so expiry and lapse continue while no user is clicking the web UI. It should poll due records at a short interval, use database locks/conditional transitions to avoid duplicate actions, and write system-actor audit events.

## 7. Build sequence

1. **Runnable foundation:** React frontend, Python backend shell, settings, Docker Compose, PostgreSQL/MongoDB health checks, migrations, and seeded `OWNER`/`CLAIMANT` accounts.
2. **Owner estate setup:** authentication, estate profile, assets/ownership/nominees/claimants, process-rule seed data, and audit trail.
3. **Documents and extraction:** encrypted vault, upload metadata, Mongo candidate storage, extraction review, confirmation transaction, and retention cleanup.
4. **Release path:** death-certificate checks, veto UI and simulated notices, expiry worker, atomic release procedure, claimant permissions and summary.
5. **Claimant workflows:** assigned-asset views, required/optional documents, checklists, disputes, withdrawal, correction, lapse, and archive lifecycle.
6. **Recovery and demo polish:** coordinated backup/restore, synthetic fixtures, reproducible reset, and a scripted Owner-to-Claimant demonstration.

Each stage should leave a runnable, demonstrable path. Implement each as a vertical slice across UI, service, storage/database, and verification rather than completing all UI first or all SQL first.

## 8. Decisions still to confirm before implementation tickets

1. **LLM-generated claimant answers:** deferred by the user; pgvector retrieval is approved, but whether an LLM summarizes results is undecided.
2. **Testing and academic evaluation:** defer the detailed scope until implementation and the teacher's submission requirements make it timely.
3. **ER model:** the complete logical ER model is available as a nine-sheet Chen-notation set in [`docs/diagrams/README.md`](diagrams/README.md). Review it before turning it into migrations; the diagram set does not itself define the physical schema.

After confirming these points, convert the plan into implementation tickets. Keep this architecture plan and accepted ADRs as the source of technical constraints.
