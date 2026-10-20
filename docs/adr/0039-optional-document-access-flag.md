# 0039: Optional Document Access Flag

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  The owner can block optional claimant document access, but a document required for an assigned claim must remain available. ADR 0031 already sets the default and release lock; the remaining design choice is how to store and audit the preference.

- **Decision**:
  1. Store optional document access as a Boolean `allow_claimant_document_download` preference scoped to a claimant and document, defaulting to `TRUE`.
  2. The owner may turn the preference off or back on while the estate is `ACTIVE`. Lock it when a claimant files a release request.
  3. Required documents remain viewable and downloadable regardless of the preference.
  4. Audit every preference change, as well as each claimant document view and download. Do not create a separate consent-record entity for this setting.

- **Consequences**:
  - **Positive**: The owner controls optional disclosure without blocking a required claim document.
  - **Trade-off**: The owner cannot change the preference once release is requested.
