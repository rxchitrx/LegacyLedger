# 0019: Real-World Dataset Grounding (AgamiAI & casparser Standards) for Evaluation

- **Status**: Superseded in part by ADR 0035
- **Date**: 2026-10-18
- **Context**:
  To satisfy faculty expectations and validate extraction robustness, using solely artificial in-house mock data can be perceived as synthetic bias or an over-simplified benchmark.
  However, real Indian financial documents containing active personal identities (PAN, bank numbers, folio balances) cannot be committed due to DPDP regulations.
  Public open-source benchmark repositories—namely `AgamiAI/Indian-Bank-Statements` (Hugging Face) and the industry-standard `codereverser/casparser` layout models—provide real-world layout structures.

- **Decision**:
  1. Base the document testing suite on established public datasets and layout standards:
     - Bank statements: Grounded in `AgamiAI/Indian-Bank-Statements` formatting (HDFC, SBI, ICICI layout structures with authentic IFSC and transaction narrations).
     - Mutual fund statements: Formatted according to the structural schema and token layouts defined by `codereverser/casparser` (CAMS / KFintech standard formats).
     - Death certificate: Modeled directly after the official Civil Registration System (CRS India Form 6) standard.
  2. Synthesization is strictly limited to data masking and persona binding (injecting masked demo identities while preserving 100% of the real-world document layout, typography, and tabular structure).

- **Consequences**:
  - **Positive**: High credibility with academic evaluators; demonstrates alignment with recognized industry document AI datasets and open-source benchmarks.
  - **Trade-off**: Requires maintaining test fixtures aligned with external benchmark schemas.

- **Amendment (ADR 0035)**: Dataset research 17 supersedes the bank-layout claim: AgamiAI files are synthetic current-account fixtures and do not provide HDFC/SBI/ICICI layouts. Use them only for parser/OCR fixtures and narration examples. Seed institution-specific claim rules from official sources; retain the CAS and CRS fixture guidance where supported.
