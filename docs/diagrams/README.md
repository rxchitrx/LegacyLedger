# LegacyLedger — Diagrams & Documents Index

This index separates **NEW / CURRENT** deliverables (aligned with the two-role `OWNER` / `CLAIMANT` model and ADRs `0001`–`0045`) from **OLD / INITIAL SUBMISSION** snapshots kept for reference.

## Quick Status Overview

| Area | Status | Location | Notes |
|---|---|---|---|
| **Technical Architecture Plan** | **NEW / CURRENT** | [`docs/architecture-plan.md`](../architecture-plan.md) | React, FastAPI, PostgreSQL (`pgvector`/`pgcrypto`), MongoDB, AES-256-GCM Vault, Docker Compose |
| **ER Model (9-Sheet + Mermaid + Overview)** | **NEW / CURRENT** | [`er-model/`](er-model/) | Complete 22-table logical ER model reflecting ADRs `0001`–`0045` |
| **Normalized Tables (Up to 3NF)** | **NEW / CURRENT** | [`normalized-tables/`](normalized-tables/) | Elmasri & Navathe (6th Ed.) 1NF→3NF proof + 22-table 3NF schema |
| **Design of Forms, Security & Validation** | **NEW / CURRENT** | [`forms-wireframes/`](forms-wireframes/) | Monochrome wireframes for all 8 `ADR 0042` forms + Elmasri Ch. 24/3/5 submission PDF |
| **Data Flow Diagram (DFD)** | **NEW / CURRENT** | [`relational-and-dfd/LegacyLedger-DFD-A4.pdf`](relational-and-dfd/LegacyLedger-DFD-A4.pdf) | Level 0, Level 1, and Level 2 DFDs reflecting current Owner/Claimant release flow |
| **Relational Mapping (from old ER)** | **OLD / SUPERSEDED** | [`relational-and-dfd/LegacyLedger-Relational-Mapping.pdf`](relational-and-dfd/LegacyLedger-Relational-Mapping.pdf) | Mapped from the initial simplified teacher-submitted ER PDF |
| **Initial Submitted Synopsis, SRS & ER** | **OLD / INITIAL SUBMISSION** | [`docs/submitted/`](../submitted/) | Original teacher-submitted snapshots (contain older Executor/Reviewer/Admin roles) |

## 1. ER Model — **NEW / CURRENT** (`er-model/`)

| Sheet | Scope | Editable | PNG |
|---|---|---|---|
| Overview | Combined Updated ER Overview | [Excalidraw](er-model/LegacyLedger-ER-Updated-Overview.excalidraw) | [PNG](er-model/LegacyLedger-ER-Updated-Overview.png) |
| Mermaid | Mermaid Logical Schema (`22 tables`) | [MMD](er-model/LegacyLedger-ER-Mermaid.mmd) · [Excalidraw](er-model/LegacyLedger-ER-Mermaid.excalidraw) | [PNG](er-model/LegacyLedger-ER-Mermaid.png) |
| 1 | Core estate model | [Excalidraw](er-model/LegacyLedger-ER-01-core.excalidraw) | [PNG](er-model/LegacyLedger-ER-01-core.png) |
| 2 | Owner designates claimants to assets | [Excalidraw](er-model/LegacyLedger-ER-02-claimant-assignment.excalidraw) | [PNG](er-model/LegacyLedger-ER-02-claimant-assignment.png) |
| 3 | Joint ownership share | [Excalidraw](er-model/LegacyLedger-ER-03-ownership.excalidraw) | [PNG](er-model/LegacyLedger-ER-03-ownership.png) |
| 4 | Nominations and appointees | [Excalidraw](er-model/LegacyLedger-ER-04-nomination.excalidraw) | [PNG](er-model/LegacyLedger-ER-04-nomination.png) |
| 5 | Document metadata and asset links | [Excalidraw](er-model/LegacyLedger-ER-05-documents.excalidraw) | [PNG](er-model/LegacyLedger-ER-05-documents.png) |
| 6 | Release request and asset outcomes | [Excalidraw](er-model/LegacyLedger-ER-06-release.excalidraw) | [PNG](er-model/LegacyLedger-ER-06-release.png) |
| 7 | Claim workflow and permission | [Excalidraw](er-model/LegacyLedger-ER-07-workflows.excalidraw) | [PNG](er-model/LegacyLedger-ER-07-workflows.png) |
| 8 | Process rules and checklist generation | [Excalidraw](er-model/LegacyLedger-ER-08-rules.excalidraw) | [PNG](er-model/LegacyLedger-ER-08-rules.png) |
| 9 | Corrections and audit | [Excalidraw](er-model/LegacyLedger-ER-09-corrections-audit.excalidraw) | [PNG](er-model/LegacyLedger-ER-09-corrections-audit.png) |

## 2. Normalized Tables (Up to 3NF) — **NEW / CURRENT** (`normalized-tables/`)

- **Combined 2-Page Submission PDF:** [`LegacyLedger-Normalized-Tables-Combined.pdf`](normalized-tables/LegacyLedger-Normalized-Tables-Combined.pdf)
- **Step-by-Step 1NF → 2NF → 3NF Proof:** [Excalidraw](normalized-tables/LegacyLedger-Normalization-1NF-to-3NF.excalidraw) · [PNG](normalized-tables/LegacyLedger-Normalization-1NF-to-3NF.png)
- **Complete 22-Table 3NF Schema:** [Excalidraw](normalized-tables/LegacyLedger-Normalized-Tables-3NF.excalidraw) · [PNG](normalized-tables/LegacyLedger-Normalized-Tables-3NF.png)
- **Editable Monochrome Word Copy (22 Native Tables):** [`LegacyLedger-22-Normalized-Tables-Monochrome.docx`](normalized-tables/LegacyLedger-22-Normalized-Tables-Monochrome.docx)

## 3. Design of Forms, Security & Validation — **NEW / CURRENT** (`forms-wireframes/`)

- **Full Submission PDF (8 pages, includes both wireframe sheets):** [`LegacyLedger-Forms-Security-Validation.pdf`](forms-wireframes/LegacyLedger-Forms-Security-Validation.pdf)
- **Sheet 1 (Forms 1–4 — Auth & Owner Portal):** [Excalidraw](forms-wireframes/LegacyLedger-Forms-Sheet1-Owner.excalidraw) · [PNG](forms-wireframes/LegacyLedger-Forms-Sheet1-Owner.png)
- **Sheet 2 (Forms 5–8 — Release, Claimant, Summary & Privacy):** [Excalidraw](forms-wireframes/LegacyLedger-Forms-Sheet2-Release-Claimant.excalidraw) · [PNG](forms-wireframes/LegacyLedger-Forms-Sheet2-Release-Claimant.png)

## 4. Data Flow Diagrams & Legacy Relational Mapping (`relational-and-dfd/`)

- **NEW / CURRENT — DFD (Level 0, 1, 2):** [`LegacyLedger-DFD-A4.pdf`](relational-and-dfd/LegacyLedger-DFD-A4.pdf)
- **OLD / SUPERSEDED — Relational Mapping (from initial submitted ER):** [`LegacyLedger-Relational-Mapping.pdf`](relational-and-dfd/LegacyLedger-Relational-Mapping.pdf)
- **Editable Source:** [`LegacyLedger-Diagrams.excalidraw`](relational-and-dfd/LegacyLedger-Diagrams.excalidraw)

## 5. Initial Teacher-Submitted Snapshots — **OLD / INITIAL SUBMISSION** (`docs/submitted/`)

- [`DBMS_Synopsis_format_2026.pdf`](../submitted/DBMS_Synopsis_format_2026.pdf) (**OLD**)
- [`Legacy_Ledger_Specs_Requirements.pdf`](../submitted/Legacy_Ledger_Specs_Requirements.pdf) (**OLD**)
- [`LegacyLedger-ER-clean-monochrome.pdf`](../submitted/LegacyLedger-ER-clean-monochrome.pdf) (**OLD**)
