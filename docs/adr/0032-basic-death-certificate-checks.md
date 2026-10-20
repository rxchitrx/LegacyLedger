# 0032: Basic Death Certificate Checks

- **Status**: Accepted
- **Date**: 2026-10-20
- **Context**:
  Estate release is filed by a claimant and automatically approved after the owner's veto window unless the owner vetoes (ADR 0030). The demo needs basic checks before release, but it does not integrate with government certificate registries and must not claim to authenticate a certificate.

- **Decision**:
  1. On submission, the system checks that a death certificate document is present and readable, and that the deceased person's name on it matches the estate owner's recorded name.
  2. These checks establish document completeness/readability and a name match only. They do not verify that the certificate is genuine or issued by an authority.
  3. If the document is unreadable or the name does not match, the request remains pending and release is blocked. The claimant must upload a corrected certificate.
  4. When a corrected certificate passes both checks, the owner's veto window starts again. If the owner does not veto before that window expires, the system automatically approves release as in ADR 0030.
  5. Record each submission and its check outcome in the audit log. Show the claimant whether the document was unreadable or the name failed to match, without exposing unrelated estate information.

- **Consequences**:
  - **Positive**: Obvious document and name errors cannot trigger automatic release, and the owner receives a full veto window after a valid upload.
  - **Trade-off**: A passing certificate is not proven genuine; the demo must describe the result as basic checks, not certificate authentication.
