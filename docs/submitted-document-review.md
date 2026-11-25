# Submitted Documents: Technical Decisions to Resolve

**Status:** Review of submitted drafts; recommendations below are not approved implementation decisions.  
**Reviewed:** 2026-10-21

## Source documents

- [DBMS synopsis](submitted/DBMS_Synopsis_format_2026.pdf)
- [ER diagram](submitted/LegacyLedger-ER-clean-monochrome.pdf)
- [Software requirements](submitted/Legacy_Ledger_Specs_Requirements.pdf)

These are the copies submitted to the teacher. The user says they are not final. Preserve them as reference snapshots; update working architecture/specs separately after decisions.

## What the submissions specify

- **Product:** browser-based digital estate continuity and claim-guidance web system.
- **Relational core:** PostgreSQL, normalized financial/access data, constraints, ACID transactions, views, stored procedures, triggers, and audit records.
- **NoSQL boundary:** MongoDB for semi-structured extraction candidates keyed to PostgreSQL document/extraction metadata, plus durable uploaded-file version history. The user chose not to retain extraction/review revisions; extraction can be rerun from a retained file version.
- **Original files:** encrypted local file storage, outside both databases.
- **File encryption:** the user selected AES-256-GCM for every uploaded file version; a fresh unique nonce is used for each encryption. The application library and encryption-key handling remain to be selected.
- **Backend options:** Python 3.11+, FastAPI, SQLAlchemy/psycopg 3, PyMongo, Pydantic, and pytest.
- **Frontend options:** React.js web app or Streamlit; the documents do not choose between them.
- **Database extensions:** pgcrypto and pgvector are listed. The user approved pgvector for semantic retrieval over approved, versioned official guidance to support cited claimant Q&A; structured PostgreSQL process rules remain authoritative for checklists. The user approved pgcrypto for keyed HMAC-SHA-256 identifier fingerprints only, using a stable protected local secrets file excluded from Git and kept separate from database backups.
- **Document processing:** PyMuPDF/pdfplumber, Tesseract for scans, synthetic-data generation with Faker, and an optional LLM extraction fallback. The user selected Google Gemini API model `gemini-3.8-flash` for that fallback. The entire demo uses synthetic documents only, including anything sent to Gemini. The API key will be provided later and must be held in runtime secrets, never committed. Whether an LLM summarizes retrieved guidance for claimants is deferred.
- **Deployment/tooling:** Docker Compose, Windows 11/macOS development, Git/GitHub, MongoDB Community/Compass, and Postman.
- **Evaluation:** synthetic masked fixtures, extraction exact-match/correction-rate measures, and demoable database behavior.

## Conflicts with newer decisions

These submitted drafts contain earlier ideas that are superseded by decisions made later in this project. Do not carry these forward unless the user explicitly reopens them:

- The specs list Trusted Contact, Executor, Reviewer, and Admin roles and an executor/reviewer death-release approval. The current product has only **Owner** and **Claimant** accounts; the owner may veto and the system releases after the configured window.
- The synopsis describes human-approved, deny-by-default release. Current decisions specify the death-certificate checks, veto window, and automatic release path.
- The ER diagram is a simplified earlier model. It does not fully represent the current account/person identity, one-estate-per-owner, release request and veto state, versioned process guidance, asset-scoped claimant workflow assignment, document-to-many-assets sharing, optional/required disclosure, or system lapse/archive lifecycle.
- The synopsis says MongoDB stores document version history as well as extraction candidates. User selected uploaded file versions only; extraction/review drafts are not retained and can be regenerated from the encrypted file. Actual file bytes remain in the encrypted vault, with PostgreSQL authoritative for asset links and access.
- The synopsis proposes AI retrieval and cited claim guidance. Current ADR 0003 makes claim requirements deterministic and source-backed, and limits AI from authoring legal checklists. Any AI Q&A must remain anchored to approved source/rule records.

## Recommended architecture direction (not yet approved)

For a conventional browser web application, use **React frontend + FastAPI backend**. Keep the already specified Python service layer behind FastAPI; it can call PostgreSQL, MongoDB, and the encrypted file vault. This aligns with the software requirements and cleanly separates browser presentation from authorization and business logic. Streamlit remains a viable faster academic demo, but choosing both would create two frontends to maintain.

Use PostgreSQL as the authoritative store for users, estates, assets, relationships, rules, claims, permissions, the current document record, asset links, and audit events. Use MongoDB for unverified extraction candidates and uploaded-file version history only; re-run extraction from a retained file version if needed. Keep all file bytes in the AES-256-GCM encrypted vault.

Treat PostgreSQL stored procedures, constraints, views, and triggers as required DBMS deliverables. Use pgcrypto only for keyed HMAC-SHA-256 database-side `identifier_hash` fingerprints; use application-managed authenticated encryption for vault files as specified in the existing storage ADR. The user approved pgvector for semantic retrieval over approved, versioned official guidance for cited claimant Q&A. Ordinary relational rule matching continues to generate deterministic checklists.

Always run deterministic PDF text extraction and local OCR first, followed by Owner review. Use Google Gemini API model `gemini-3.8-flash` only as an optional fallback when local extraction cannot produce usable results; it may process synthetic demo documents only. If Gemini is unavailable, keep local results available for Owner review and show that the fallback did not run. The API key will be supplied later through runtime secrets, not committed to the project. Gemini must not invent or change process rules.

## Decision conversation order

Resolve these with the user one at a time. For each, explain the context, ask the question, and give a recommendation before recording the answer.

1. Frontend: React or Streamlit.
2. Backend shape: FastAPI service or Streamlit calling Python services directly (depends on item 1).
3. pgcrypto HMAC: use a stable local secrets file excluded from Git and separate from database backups; pgvector is approved for source-grounded retrieval and cited claimant Q&A.
4. MongoDB document-version scope: uploaded file versions only; extraction/review revisions are regenerated when needed.
5. Document extraction: local parsing/OCR runs first; Gemini 3.8 Flash is the fallback for unusable local results, synthetic documents only. If Gemini is unavailable, the Owner reviews local results.
6. File-vault encryption: use a generated key in a local secrets file excluded from Git; back it up separately from the database and encrypted files for the local demo. Revisit managed key storage before hosting.
7. Authentication uses seeded username/password accounts and a secure, HTTP-only browser session cookie; no registration or password-reset screen is needed.
8. Background work: veto expiry, inactivity lapse, retryable cleanup, and archive checks; decide process/scheduler shape.
9. The local Docker Compose demo, including a separate worker service on the developer's computer, is approved. No hosted URL is needed for the current scope.
10. Testing and academic evaluation: defer scope decisions until implementation and the teacher's submission requirements make them timely.
11. The complete working ER model is available as a nine-sheet Chen-notation set in the [diagram index](diagrams/README.md), with editable Excalidraw sources and PNG/SVG previews. It is a logical design for review before schema migrations; the teacher-submitted PDF remains unchanged.

## First discussion: frontend choice

The software requirements list both React and Streamlit. The user prioritized visual quality, responsiveness, and flexibility over build speed, selecting React as the working frontend choice. The existing Streamlit ADR was based on fast DBMS demonstrations and should be revisited when architecture decisions are finalized.

**Decisions:** React frontend and one modular FastAPI backend are approved. FastAPI coordinates PostgreSQL, MongoDB, and file-vault operations; those operations may be sequential or parallel only as the use case allows. MongoDB stores durable history of uploaded file versions only; extraction/review drafts are rerun when needed rather than retained.
