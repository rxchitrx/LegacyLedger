# 0045: Testamentary Documents as Evidence

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  LegacyLedger currently models nominee and legal-heir claim routes. The glossary also defines an Intended Beneficiary as someone named in a testamentary document, but no decision describes how wills enter the estate record. Applicable succession rules vary, so the app should not act as a legal interpreter.

- **Decision**:
  1. Owners may upload testamentary documents, including wills, and associate them with the assets they concern.
  2. The app may record people named in those documents as intended beneficiaries, distinct from statutory nominees and verified legal heirs.
  3. A claimant with an assigned claim may view and download a relevant will when it is needed for that claim. Required claim documents remain available under ADR 0031.
  4. The app records document presence and owner-provided associations only. It does not verify legal validity, interpret testamentary language, resolve conflicts, or allocate assets based on a will.
  5. The institution or applicable legal process determines the will's effect and any additional requirements.

- **Consequences**:
  - **Positive**: Claimants can access potentially necessary evidence without LegacyLedger making legal determinations.
  - **Trade-off**: Uploading a will does not establish that it is valid or that its named beneficiary is entitled to an asset; those questions remain outside the app.
