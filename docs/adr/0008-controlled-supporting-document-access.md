# 0008: Controlled Supporting Document Access with Owner Consent and Download Auditing

- **Status**: Superseded in part by ADR 0039
- **Date**: 2026-10-18
- **Context**:
  Financial institutions (AMCs, Registrars like CAMS/KFintech, Banks) frequently require claimants to submit physical or digital copies of the original account statements, deposit receipts, or Consolidated Account Statements (CAS) to process post-death transmissions.
  However, some statements (such as CAS) co-mingle multiple holdings or folios intended for different nominees, presenting a potential privacy leakage risk under the DPDP Act.
  Completely withholding original PDFs cripples the claimant's ability to satisfy counter requirements; unconditionally sharing raw co-mingled documents without owner knowledge violates least-disclosure principles.

- **Decision**:
  1. Documents are associated with assets via an explicit `asset_document` relational link. Standalone single-asset documents (FD receipts, insurance policy bonds) are accessible to the verified claimant of that asset upon estate release.
  2. Co-mingled statements (such as CAS) are flagged with `is_shared_statement = TRUE` in the `document` table.
  3. The asset owner retains explicit control during setup via a `consent` record or flag (`allow_claimant_document_download = TRUE/FALSE`, defaulting to TRUE for claim validity).
  4. If permitted, claimants can download the supporting document accompanied by guidance indicating the relevant folio/page to present to the registrar.
  5. Every document view or download action executed by a claimant strictly records an immutable entry in `audit_event` (`DOCUMENT_DOWNLOADED` with `actor_id`, `document_id`, `ip_address`, and timestamp).

- **Consequences**:
  - **Positive**: Empowers claimants to satisfy physical counter requirements at banks and RTAs; respects owner autonomy and DPDP consent standards; maintains full evidentiary auditability.
  - **Trade-off**: Requires modeling document-to-asset relationships to support both single-asset and multi-asset links, and tracking owner consent scopes.

- **Amendment (ADR 0031)**: An assigned claimant receives the full linked document, including shared-document contents for other assets. The owner may block optional documents, but cannot block a document required by the assigned claim's process rule. Document views and downloads remain audited.

- **Amendment (ADR 0039)**: Store optional document access as an allowed-by-default per-claimant/document Boolean preference. The owner may change it before release; required documents remain available. Preference changes are audited.
