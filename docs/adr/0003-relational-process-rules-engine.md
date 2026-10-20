# 0003: Grounded Relational Process Rules Engine for Claim Roadmaps

- **Status**: Accepted
- **Date**: 2026-10-17
- **Context**:
  The system must supply post-release claimants with accurate, institution-grounded claim steps (e.g., claiming a deceased person's bank FD, mutual fund folio, or demat shares).
  Relying solely on generative LLMs at release time creates a risk of hallucinating legal documents or regulatory requirements (e.g., confusing indemnity bond thresholds or KYC form numbers).
  Furthermore, as a Database Management Systems (DBMS) project, stored procedures and relational joins must be demonstrably leveraged.

- **Decision**:
  1. Definitive claim workflows and requirements are stored relationally in PostgreSQL across `guidance_source` and `process_rule`.
  2. Each rule links to official circular metadata (e.g., RBI/2024-25/Deceased Depositors, AMFI Transmission Guidelines 2024, IRDAI Master Circular).
  3. During the atomic estate release transaction, a stored procedure matches the asset's class, institution, and nomination type against `process_rule` to insert deterministic, verifiable `workflow` and `checklist_item` rows.
  4. Generative AI is not used to author legal checklists; it is limited to document extraction (ingestion) and optional natural-language synthesis/Q&A anchored strictly to the generated checklist records.

- **Consequences**:
  - **Positive**: 100% deterministic, audit-verifiable claim instructions with zero hallucination risk; leverages SQL stored procedures and joins directly for academic evaluation.
  - **Trade-off**: Adding new institution-specific claim routes requires inserting structured seed rows in `process_rule` rather than having an LLM invent them on the fly.

- **Amendment (ADR 0035)**: Initial process rules must be linked to versioned official guidance sources; project maintainers update seed rows outside the app. Generative AI does not author or update claim rules.
