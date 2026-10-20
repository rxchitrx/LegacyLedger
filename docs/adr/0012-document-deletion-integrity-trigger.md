# 0012: Cascading Integrity Trigger Marking Asset Incomplete on Document Deletion

- **Status**: Accepted
- **Date**: 2026-10-18
- **Context**:
  In LegacyLedger, every declared asset must possess supporting documentary proof (statements, receipts, policy bonds) to enable successful post-death transmission guidance.
  If an owner deletes a verified supporting document, the parent asset is left without evidentiary backing.
  The course rubric requires implementing an active PostgreSQL trigger demonstrating relational data integrity enforcement across related entities upon deletion.

- **Decision**:
  1. An `AFTER DELETE` trigger (`trg_demote_asset_on_document_delete`) is attached to the `document` table (or join table `asset_document`).
  2. When a supporting document is deleted:
     - The trigger queries whether any remaining verified documents are attached to the affected `asset_id`.
     - If no valid verified document remains, the trigger updates `asset.status = 'INCOMPLETE_DOCUMENTATION'`.
     - The trigger inserts an `audit_event` noting that the asset was demoted due to document deletion.
  3. Assets in `INCOMPLETE_DOCUMENTATION` state are excluded from eligible post-release workflows or flagged as deficient until a replacement document is uploaded and verified.

- **Consequences**:
  - **Positive**: Directly satisfies syllabus requirement for cascading integrity triggers; prevents orphaned assets without evidence from generating un-grounded claim workflows.
  - **Trade-off**: Requires the owner to re-upload evidence to restore the asset to `READY` status.
