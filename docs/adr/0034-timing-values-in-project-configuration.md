# 0034: Timing Values in Project Configuration

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  The application has only `OWNER` and `CLAIMANT` roles, so there is no in-app administrator to manage global timing settings. The veto window, claim-inactivity threshold, and stale-asset warning age need clear values for the demo.

- **Decision**:
  1. Store timing values in project/deployment configuration, outside the application UI. Neither owners nor claimants can change them in the app.
  2. Use these demo values:
     - Owner veto window: **2 minutes**.
     - Claim inactivity threshold: **180 days**.
     - Stale-asset warning age: **365 days**.
  3. These values are read by the application and database logic as applicable. Changing them is a configuration/deployment change, not an application action or database audit event.
  4. This decision sets only the claim-inactivity threshold; the automated lapse/closure behavior is defined in ADR 0044.

- **Consequences**:
  - **Positive**: Global timing policy stays out of the owner and claimant UI, while the demo has explicit values for all three timers.
  - **Trade-off**: Changing a timing value requires changing project/deployment configuration; it cannot be adjusted live by an app user.
