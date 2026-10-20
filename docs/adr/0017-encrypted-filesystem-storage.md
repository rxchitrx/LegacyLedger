# 0017: Encrypted Filesystem Document Storage Over Database BLOBs

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  Original PDF and image documents (bank statements, mutual fund CAS receipts, policy bonds, simulated death certificates) can range from several hundred kilobytes to multiple megabytes.
  Storing file binaries inside PostgreSQL (`BYTEA`) or MongoDB causes significant storage bloat, degrades buffer cache efficiency, and slows down database backups.
  The official synopsis submitted to the faculty explicitly states: *"Original files live in separate encrypted file storage, not in either database."*

- **Decision**:
  1. Store all original uploaded file binaries in an encrypted directory on the local filesystem (`/data/vault/documents/`).
  2. The PostgreSQL `document` table stores only canonical file metadata: `storage_path`, `sha256_hash`, `file_size_bytes`, `mime_type`, and verification flags.
  3. The application service layer handles symmetric encryption/decryption (AES-256) at rest when reading from or writing to the file store.

- **Consequences**:
  - **Positive**: Strict alignment with submitted academic synopsis; high relational query performance; avoids database bloat.
  - **Trade-off**: Requires maintaining filesystem storage paths and ensuring file synchronization during database resets or backups.

- **Amendment (ADR 0043)**: For the local demo, PostgreSQL, MongoDB, and the encrypted vault are backed up and restored as one coordinated set; the matching encryption key is stored separately in a protected location.
