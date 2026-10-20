# 0041: Purpose-Based Personal Data Retention and Erasure

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  LegacyLedger stores personal details, encrypted source documents, MongoDB extraction candidates, and immutable audit events. The project must not treat audit immutability as a blanket reason to retain every personal-data value forever. The official DPDP commencement notice schedules sections 8 and 11–17 to commence 18 months after 13 November 2025; the Act's erasure duties include exceptions where retention is necessary for a specified purpose or compliance with law.

- **Decision**:
  1. Apply purpose-based retention by data class; do not invent one universal retention duration. Keep personal data only while it serves the stated purpose or an applicable law requires it. Record the specific legal or claim basis and review condition for any hold.
  2. Delete each MongoDB extraction candidate when the owner finishes review of that candidate (accepts or rejects it). Do not retain duplicate extraction payloads after typed records have been confirmed.
  3. Provide a way for an owner or claimant to request correction or erasure of their own personal data. Erase data when its purpose has ended unless a documented legal/claim retention basis applies; respond with the retained fields and reason when erasure is limited.
  4. Keep append-only audit events free of raw document contents and unnecessary personal details. Use pseudonymous actor references and event metadata. Keep the identity mapping separately so it can be erased when no retention basis remains; retain event details containing personal data only under a documented basis.
  5. Preserve legal or institutional records only for the applicable retention period; do not claim that every estate or audit record must be kept permanently.
  6. Apply any statutory minimum retention floor only where its stated purpose and scope apply; it does not authorize unrelated or indefinite retention.

- **Consequences**:
  - **Positive**: The audit history can remain useful while unnecessary personal data and extraction payloads can be erased.
  - **Trade-off**: Each retained data class needs an explicit purpose and any longer legal hold needs a recorded basis; this is a demo policy and must be reviewed against applicable law before real deployment.

- **Sources**:
  - DPDP Act, 2023, sections 8, 12, and 17: https://www.meity.gov.in/static/uploads/2024/02/Digital-Personal-Data-Protection-Act-2023-1.pdf
  - Commencement notification G.S.R. 843(E), 13 November 2025: https://www.meity.gov.in/static/uploads/2025/11/c56ceae6c383460ca69577428d36828b.pdf
