# 0043: Local Demo Deployment and Coordinated Backup

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  The demo combines Streamlit, PostgreSQL, MongoDB, and an encrypted filesystem document vault. Restoring only one store can leave database metadata and encrypted files inconsistent.

- **Decision**:
  1. Run the demo locally with Docker Compose for Streamlit, PostgreSQL, and MongoDB. Mount the encrypted document vault as persistent storage.
  2. Create one timestamped backup set containing a PostgreSQL dump, MongoDB dump, and vault snapshot from the same stopped/quiesced application state, plus a manifest identifying the components, time, and app/config version.
  3. Keep the encryption key in a separate protected location, outside the backup archive. A restore is complete only when the matching key and all three data components are available.
  4. Restore the three components as one set; do not reset either database independently while retaining an unmatched vault.

- **Consequences**:
  - **Positive**: The demo has a reproducible local setup and a clear whole-system restore unit.
  - **Trade-off**: The maintainer must protect the encryption key separately and coordinate snapshots across storage systems.
