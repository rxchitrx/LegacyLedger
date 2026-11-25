db = db.getSiblingDB("legacyledger");

db.extraction_candidates.insertOne({
  extraction_id: "ext_2026_0001",
  pg_document_id: 1,
  engine: "PyMuPDF + Tesseract (local-first)",
  status: "PENDING_OWNER_REVIEW",
  extracted_fields: [
    { field: "institution_name", value: "HDFC Bank Ltd.", confidence: 0.98, page: 1 },
    { field: "account_mask",     value: "XXXX-XXXX-4821", confidence: 0.96, page: 1 },
    { field: "nominee_name",     value: "Meera Rao",      confidence: 0.94, page: 2 }
  ],
  created_at: new Date()
});

db.file_versions.insertOne({
  version_id: "ver_2026_0001_v1",
  pg_document_id: 1,
  vault_object_id: "vault_aes256gcm_9f3a8c1b",
  encryption: "AES-256-GCM",
  sha256: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  uploaded_at: new Date()
});
