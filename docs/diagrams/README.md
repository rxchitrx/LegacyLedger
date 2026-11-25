# LegacyLedger — Diagrams & Documents Index

This index clearly separates **CURRENT / NEW** deliverables (aligned with the two-role `OWNER` / `CLAIMANT` model and ADRs `0001`–`0045`) from **OLD / SUPERSEDED** earlier drafts kept for historical reference.

## Quick Status Overview

| Area | Status | Location | Notes |
|---|---|---|---|
| **Technical Architecture Plan** | **NEW / CURRENT** | [`docs/architecture-plan.md`](../architecture-plan.md) | Current stack (React, FastAPI, PostgreSQL + pgvector/pgcrypto, MongoDB, AES-256-GCM Vault, Docker Compose) |
| **ER Model (9-Sheet + Mermaid + Overview)** | **NEW / CURRENT** | [`er-model/`](er-model/) | Complete 22-table logical ER model reflecting ADRs `0001`–`0045` |
| **Normalized Tables (Up to 3NF)** | **NEW / CURRENT** | [`normalized-tables/`](normalized-tables/) | Elmasri & Navathe (6th Ed.) 1NF→3NF proof + 22-table 3NF schema (Excalidraw, PNG, SVG, PDF, DOCX) |
| **Design of Forms, Security & Validation** | **NEW / CURRENT** | [`forms-wireframes/`](forms-wireframes/) | Monochrome wireframes for all 8 `ADR 0042` forms + Elmasri Ch. 24/3/5 submission PDF |
| **Data Flow Diagram (DFD)** | **NEW / CURRENT** | [`relational-and-dfd/LegacyLedger-DFD-A4.pdf`](relational-and-dfd/LegacyLedger-DFD-A4.pdf) | Level 0, Level 1, and Level 2 DFDs reflecting current Owner/Claimant release flow |
| **Submitted Document Review** | **NEW / CURRENT** | [`docs/submitted-document-review.md`](../submitted-document-review.md) | Tracks exact differences between initial submitted PDFs and newer accepted ADRs |
| **Earlier Normalized-Table Drafts** | **OLD / SUPERSEDED** | [`normalized-tables/archive-old/`](normalized-tables/archive-old/) | Older vertical-card / pre-ADR attempts (had redundant keys and missing fields) |
| **Relational Mapping (from old ER)** | **OLD / SUPERSEDED** | [`relational-and-dfd/LegacyLedger-Relational-Mapping.pdf`](relational-and-dfd/LegacyLedger-Relational-Mapping.pdf) | Mapped from the initial simplified teacher-submitted ER PDF |
| **Initial Submitted Synopsis, SRS & ER** | **OLD / SUPERSEDED** | [`docs/submitted/`](../submitted/) | Original teacher-submitted snapshots (contain older Executor/Reviewer/Admin roles) |

## 1. ER Model — **NEW / CURRENT** (`er-model/`)

Complete logical ER model in Chen notation, split into 9 focused sheets plus a Mermaid overview and combined overview diagram.

| Sheet | Scope | Editable | PNG | SVG |
|---|---|---|---|---|
| Overview | Combined Updated ER Overview | [Excalidraw](er-model/LegacyLedger-ER-Updated-Overview.excalidraw) | [PNG](er-model/LegacyLedger-ER-Updated-Overview.png) | — |
| Mermaid | Mermaid Logical Schema (`22 tables`) | [MMD](er-model/LegacyLedger-ER-Mermaid.mmd) · [Excalidraw](er-model/LegacyLedger-ER-Mermaid.excalidraw) | [PNG](er-model/LegacyLedger-ER-Mermaid.png) | — |
| 1 | Core estate model | [Excalidraw](er-model/LegacyLedger-ER-01-core.excalidraw) | [PNG](er-model/LegacyLedger-ER-01-core.png) | [SVG](er-model/LegacyLedger-ER-01-core.svg) |
| 2 | Owner designates claimants to assets | [Excalidraw](er-model/LegacyLedger-ER-02-claimant-assignment.excalidraw) | [PNG](er-model/LegacyLedger-ER-02-claimant-assignment.png) | [SVG](er-model/LegacyLedger-ER-02-claimant-assignment.svg) |
| 3 | Joint ownership share | [Excalidraw](er-model/LegacyLedger-ER-03-ownership.excalidraw) | [PNG](er-model/LegacyLedger-ER-03-ownership.png) | [SVG](er-model/LegacyLedger-ER-03-ownership.svg) |
| 4 | Nominations and appointees | [Excalidraw](er-model/LegacyLedger-ER-04-nomination.excalidraw) | [PNG](er-model/LegacyLedger-ER-04-nomination.png) | [SVG](er-model/LegacyLedger-ER-04-nomination.svg) |
| 5 | Document metadata and asset links | [Excalidraw](er-model/LegacyLedger-ER-05-documents.excalidraw) | [PNG](er-model/LegacyLedger-ER-05-documents.png) | [SVG](er-model/LegacyLedger-ER-05-documents.svg) |
| 6 | Release request and asset outcomes | [Excalidraw](er-model/LegacyLedger-ER-06-release.excalidraw) | [PNG](er-model/LegacyLedger-ER-06-release.png) | [SVG](er-model/LegacyLedger-ER-06-release.svg) |
| 7 | Claim workflow and permission | [Excalidraw](er-model/LegacyLedger-ER-07-workflows.excalidraw) | [PNG](er-model/LegacyLedger-ER-07-workflows.png) | [SVG](er-model/LegacyLedger-ER-07-workflows.svg) |
| 8 | Process rules and checklist generation | [Excalidraw](er-model/LegacyLedger-ER-08-rules.excalidraw) | [PNG](er-model/LegacyLedger-ER-08-rules.png) | [SVG](er-model/LegacyLedger-ER-08-rules.svg) |
| 9 | Corrections and audit | [Excalidraw](er-model/LegacyLedger-ER-09-corrections-audit.excalidraw) | [PNG](er-model/LegacyLedger-ER-09-corrections-audit.png) | [SVG](er-model/LegacyLedger-ER-09-corrections-audit.svg) |

## 2. Normalized Tables (Up to 3NF) — **NEW / CURRENT** (`normalized-tables/`)

Built using **Elmasri & Navathe, *Fundamentals of Database Systems* (6th Ed., Figs. 3.7, 9.2, 15.11 & 15.12)** horizontal-bar notation for all 22 PostgreSQL tables:

- **Combined 2-Page Submission PDF:** [`LegacyLedger-Normalized-Tables-Combined.pdf`](normalized-tables/LegacyLedger-Normalized-Tables-Combined.pdf)
- **Step-by-Step 1NF → 2NF → 3NF Proof:** [Excalidraw](normalized-tables/LegacyLedger-Normalization-1NF-to-3NF.excalidraw) · [PNG](normalized-tables/LegacyLedger-Normalization-1NF-to-3NF.png) · [SVG](normalized-tables/LegacyLedger-Normalization-1NF-to-3NF.svg)
- **Complete 22-Table 3NF Schema:** [Excalidraw](normalized-tables/LegacyLedger-Normalized-Tables-3NF.excalidraw) · [PNG](normalized-tables/LegacyLedger-Normalized-Tables-3NF.png) · [SVG](normalized-tables/LegacyLedger-Normalized-Tables-3NF.svg)
- **Editable Word (.docx) Exports (22 Native Tables):**
  - Monochrome (recommended for print): [`LegacyLedger-22-Normalized-Tables-Monochrome.docx`](normalized-tables/LegacyLedger-22-Normalized-Tables-Monochrome.docx)
  - Color-coded PK/FK shading: [`LegacyLedger-22-Normalized-Tables.docx`](normalized-tables/LegacyLedger-22-Normalized-Tables.docx)
  - Embedded visual diagram copy: [`LegacyLedger-Normalized-Tables-3NF.docx`](normalized-tables/LegacyLedger-Normalized-Tables-3NF.docx)
- **OLD / SUPERSEDED drafts** are preserved in [`normalized-tables/archive-old/`](normalized-tables/archive-old/).

## 3. Design of Forms, Security & Validation — **NEW / CURRENT** (`forms-wireframes/`)

Monochrome academic wireframes for all 8 `ADR 0042` forms (Elmasri & Navathe §2.3.2) paired with the Chapter 24 Security and Chapters 3/5/24 Validation specification:

- **Full Submission PDF (8 pages, includes both wireframe sheets):** [`LegacyLedger-Forms-Security-Validation.pdf`](forms-wireframes/LegacyLedger-Forms-Security-Validation.pdf)
- **Sheet 1 (Forms 1–4 — Auth & Owner Portal):** [Excalidraw](forms-wireframes/LegacyLedger-Forms-Sheet1-Owner.excalidraw) · [PNG](forms-wireframes/LegacyLedger-Forms-Sheet1-Owner.png) · [SVG](forms-wireframes/LegacyLedger-Forms-Sheet1-Owner.svg)
- **Sheet 2 (Forms 5–8 — Release, Claimant, Summary & Privacy):** [Excalidraw](forms-wireframes/LegacyLedger-Forms-Sheet2-Release-Claimant.excalidraw) · [PNG](forms-wireframes/LegacyLedger-Forms-Sheet2-Release-Claimant.png) · [SVG](forms-wireframes/LegacyLedger-Forms-Sheet2-Release-Claimant.svg)

## 4. Data Flow Diagrams & Legacy Relational Mapping (`relational-and-dfd/`)

- **NEW / CURRENT — DFD (Level 0, 1, 2):** [`LegacyLedger-DFD-A4.pdf`](relational-and-dfd/LegacyLedger-DFD-A4.pdf)
- **OLD / SUPERSEDED — Relational Mapping (from initial submitted ER):** [`LegacyLedger-Relational-Mapping.pdf`](relational-and-dfd/LegacyLedger-Relational-Mapping.pdf)
- **Combined Archive / Editable Source:** [`LegacyLedger-Combined.pdf`](relational-and-dfd/LegacyLedger-Combined.pdf) · [`LegacyLedger-Diagrams.excalidraw`](relational-and-dfd/LegacyLedger-Diagrams.excalidraw)

## 5. Initial Teacher-Submitted Snapshots — **OLD / SUPERSEDED** (`docs/submitted/`)

Preserved unchanged for historical comparison (see [`docs/submitted-document-review.md`](../submitted-document-review.md) for what was superseded):

- [`DBMS_Synopsis_format_2026.pdf`](../submitted/DBMS_Synopsis_format_2026.pdf) (**OLD**)
- [`Legacy_Ledger_Specs_Requirements.pdf`](../submitted/Legacy_Ledger_Specs_Requirements.pdf) (**OLD**)
- [`LegacyLedger-ER-clean-monochrome.pdf`](../submitted/LegacyLedger-ER-clean-monochrome.pdf) (**OLD**)
