# 15: Backups, restore, and deployment shape

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

How are PostgreSQL, MongoDB, and the encrypted document vault backed up, restored, and deployed together?

Undecided: the backup/restore approach and keeping vault files in sync with database resets (ADR 0017 flags this), plus the deployment shape (e.g., docker compose services) for the demo.

**Relevant refs:** ADR 0017 ("ensuring file synchronization during database resets or backups").

## Resolution

Accepted in [ADR 0043: Local Demo Deployment and Coordinated Backup](../../../docs/adr/0043-local-demo-deployment-and-backup.md). Run Streamlit, PostgreSQL, and MongoDB locally with Docker Compose and mount the encrypted vault. Back up all three as one coordinated set with a manifest; protect the encryption key separately and restore the set together.
