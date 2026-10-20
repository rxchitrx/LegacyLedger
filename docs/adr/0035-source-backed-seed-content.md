# 0035: Source-Backed Seed Content

- **Status**: Accepted
- **Date**: 2026-10-21
- **Context**:
  The demo needs a bounded starting set of financial institutions, assets, and claim rules. Prior dataset research found that the AgamiAI bank statements are synthetic current-account fixtures, not HDFC/SBI/ICICI statement layouts; casparser supports CAMS/KFintech mutual-fund CAS, NSDL/CDSL demat CAS, and NPS data.

- **Decision**:
  1. Seed the first demo for bank deposits and fixed deposits, mutual funds, demat holdings (equities and bonds), and NPS.
  2. Seed institution examples for SBI, HDFC Bank, ICICI Bank, CAMS, KFintech, NSDL, and CDSL. Add NPS claim guidance from official PFRDA/CRA sources. Do not seed life-insurance claim rules in this initial set.
  3. Each `ProcessRule` must link to a versioned `GuidanceSource` with its issuing authority, reference/title, effective date, URL, and checked date. Institution contact details are included only when found in an official source and are source-dated.
  4. Project maintainers update versioned seed data outside the app. Claimants and owners cannot edit rule content.
  5. Use AgamiAI files only as synthetic parser/OCR fixtures and narration examples. Do not present their fictional bank names or layouts as real Indian bank data. Use casparser-supported formats only where its documented coverage applies; nomination shares and minor-appointee information remain owner-declared.

- **Consequences**:
  - **Positive**: Demo claim instructions remain traceable to official guidance, while parser-fixture limits are represented honestly.
  - **Trade-off**: The initial claim catalog excludes insurance and other asset types until source-backed rules are prepared.
