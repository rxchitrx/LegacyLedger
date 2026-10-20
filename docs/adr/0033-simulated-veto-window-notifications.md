# 0033: Simulated Veto-Window Notifications

- **Status**: Accepted
- **Date**: 2026-10-20
- **Context**:
  When a claimant files a valid release request, the owner needs a clear chance to veto during the configured window (ADR 0030 / 0032). The demo should show the expected notification experience without requiring external email or WhatsApp accounts and integrations.

- **Decision**:
  1. When a valid release request starts the veto window, the demo creates an in-app alert and simulated email and WhatsApp delivery records for the owner.
  2. All three channels are recorded as simulated immediately at filing. The in-app alert remains visible to the owner until they open it or act on the request.
  3. The demo must label email and WhatsApp as simulated; it must not claim that a real message was sent or delivered.
  4. No external messages or delivery retries are performed. The notification records are for demonstration and audit visibility only.

- **Consequences**:
  - **Positive**: The demo presents the intended multi-channel alert flow without external provider setup, credentials, or messaging costs.
  - **Trade-off**: An owner outside the app will not actually receive an email or WhatsApp message; the simulated records do not provide real-world notice.
