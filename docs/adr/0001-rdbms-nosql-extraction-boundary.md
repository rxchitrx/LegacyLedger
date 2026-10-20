# 0001: Separation of Relational Financial Truth and Semi-Structured Extraction Candidates

- **Status**: Accepted
- **Date**: 2026-10-17
- **Context**:
  The system must process uploaded financial documents (PDFs, scans) to extract account numbers, institution names, holders, and nominees using NLP/OCR. 
  The project requirements mandate using PostgreSQL for 3NF relational financial data and MongoDB for semi-structured data.
  We must decide where provisional extraction drafts live before a human confirms them.

- **Decision**:
  1. When a document is uploaded, an encrypted copy is stored on disk, and a record is created in PostgreSQL's `document` table with its SHA-256 hash, storage path, and a shared `extraction_id`.
  2. The NLP/OCR engine writes the raw extraction candidate (candidate field values, confidence scores, bounding boxes, source text snippets) exclusively into MongoDB's `extraction_candidates` collection, keyed by `extraction_id`.
  3. No draft or placeholder records are created in PostgreSQL's `asset`, `ownership`, or `nomination` tables prior to human review.
  4. Only upon explicit human confirmation/editing does a PostgreSQL transaction insert the typed, verified rows into `asset`, `ownership`, and `nomination`, link the `document.asset_id`, and mark `document.is_verified = TRUE`.

- **Consequences**:
  - **Positive**: Strict 3NF relational tables remain completely free of unverified, noisy, or failed OCR records. Integrity constraints (NOT NULL, foreign keys) do not need to be relaxed to accommodate partial drafts.
  - **Trade-off**: The application layer must query MongoDB when presenting the document review UI to the user before the asset is committed to PostgreSQL.
