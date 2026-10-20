# 0014: Two-Tier Extraction Pipeline with Local Deterministic Fallback

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  The system processes financial statement PDFs and scans to extract account identifiers, institution names, holders, and nominees into MongoDB candidate records.
  Relying solely on external cloud LLM APIs creates a single point of failure during academic viva evaluations or environments with restricted/spotty internet connectivity.
  Moreover, most Indian digital financial statements (CAS, bank e-statements, deposit receipts) have native digital text layers with highly standard structural patterns (e.g. PAN, IFSC, folio masks).

- **Decision**:
  1. The extraction service implements a resilient two-tier architecture:
     - **Tier 1 (Local Deterministic Extractor)**: PyMuPDF extracts digital text streams directly. Built-in regular expressions and pattern matchers extract standard Indian identifiers (PAN `[A-Z]{5}[0-9]{4}[A-Z]`, IFSC `[A-Z]{4}0[A-Z0-9]{6}`, folio numbers, account numbers, dates) and text bounding boxes completely offline.
     - **Tier 2 (LLM Structuring Engine)**: If an LLM API key is configured and external connectivity is active, the text is enriched by an LLM for complex table layouts and nuanced nominee clauses.
  2. If Tier 2 is disabled, unreachable, or times out, Tier 1 populates the MongoDB `extraction_candidates` document independently with `extraction_engine = 'PyMuPDF+Regex'` and baseline confidence scores.
  3. Scanned image documents without a native text layer fall back to local Tesseract OCR prior to regex/LLM parsing.

- **Consequences**:
  - **Positive**: 100% offline demo resilience for academic evaluations; zero reliance on external network stability for digital statements; transparent logging of the extraction method used.
  - **Trade-off**: Requires maintaining regex pattern matchers for standard Indian financial document formats alongside LLM prompts.
