# Research: dataset coverage — formats, institutions, asset classes

Scope: verify what ADR 0019 actually names (`AgamiAI/Indian-Bank-Statements`, `codereverser/casparser`, "CRS Form 6") and what a deterministic parser tier could realistically extract from each. Web research performed 2026-10-18; all claims below are from live sources unless marked otherwise.

## Sources examined

- ADR 0019 (local, read-only): `LegacyLedger/docs/adr/0019-real-world-dataset-grounding.md` — names `AgamiAI/Indian-Bank-Statements` (Hugging Face), `codereverser/casparser` ("layout models", CAMS/KFintech), and "official Civil Registration System (CRS India Form 6)" for the death certificate. It claims the bank dataset provides "HDFC, SBI, ICICI layout structures with authentic IFSC and transaction narrations".
- AgamiAI/Indian-Bank-Statements — https://huggingface.co/datasets/AgamiAI/Indian-Bank-Statements (dataset card fetched in full; file tree + sample JSON inspected)
- codereverser/casparser — https://github.com/codereverser/casparser and https://raw.githubusercontent.com/codereverser/casparser/main/README.md (README fetched in full); PyPI: https://pypi.org/project/casparser/
- CRS / RBD Act — https://crsorgi.gov.in and https://dc.crsorgi.gov.in (portal); forms list: DCO Uttarakhand presentation at https://uaoa.gov.in/sites/default/files/2025-09/RBD%20Act%201969.pdf; sample Form-6 death certificate (UP): https://up-rera.in/ViewDocument?Param=16402967641.pdf; RBD (Amendment) Act 2023 / Model Rules 2024: https://dc.crsorgi.gov.in/assets/download/Births_and_Deaths_Rules_2024.pdf
- (Corroborating commercial API, not OSS): https://casparser.in/developers — claims 9 asset classes incl. insurance/NPS for the hosted product

## Coverage (realistically supported)

### AgamiAI Indian Bank Statement Synthetic Dataset

- Nature and scope: fully **synthetic** "Indian business bank statements"; dataset card states **current accounts (business banking) only, no personal/savings accounts**. Apache-2.0; curated by AgamiAI Inc.; train dir ~1.37 GB; sequential statement IDs with paired `.json` + `.pdf` (at least 100 pairs per folder on the first listing page).
- Statement formats (4 folders): `India_Bank_Statement_Digital_Type{1,2}` and `India_Bank_Statement_Scanned_Type{1,2}`.
  - Type 1: separate Debit / Credit columns (`Date | Description | Debit | Credit | Balance`).
  - Type 2: single signed Transaction column (`Date | Description | Transaction | Balance`).
  - Digital = text-layer PDF + JSON; Scanned = image-only PDF (~5.5–8 MB, good OCR test material) + the same JSON as ground truth.
- Fields available (JSON, verified from a downloaded sample): `bank_name`, `account_holder`, `account_holder_address`, `account_number`, `ifsc_code`, `micr_code`, `branch_name`, `branch_code`, `branch_phone`, `account_type`, `currency`, `customer_id`, `opening_balance`, `closing_balance`, `start_date`, `end_date`, `statement_date`, `interest_rate`, `transactions[]` with `date`, `value_date`, `description`, `cheque_no`, `debit`, `credit`, `balance`, `branch_code`, `failed`.
- Institutions: the dataset's own banks are **fictional**. Verified samples: "Paramount Banking Corporation" (IFSC `PARA0761987`) and "Progressive National Bank" (IFSC `PROG0920445`). **No HDFC/SBI/ICICI statement layouts exist in this dataset.** Real institution codes appear only inside narration counterparty strings: `HDFC0009038`, `HDFC0004171`, `ICIC0000011`, `ICIC0SF0002`, "CITI BANK N.A.", "HDFC BANK LTD." — i.e., real IFSCs are incidental narration tokens, not the issuing bank's layout.
- Narrations are India-authentic and varied: `UPI/DR|CR/<ref>/<name>/UPI-TRANSFER...`, `NEFT Cr/Dr-<UTR>-<IFSC>-<name>`, `RTGS Dr-CNRBR...-/URGENT/`, `IMPS ... SALARY TRF BY-...`, `Chq Paid-MICR Inward Clearing-...`, `By Clg:DEL ACCTS-...`, `CASH-BNA-SELF-...`, `Cash Withdrawal-...`, `ATM WDL-...`, `Service Charges-...`, `REVERSAL-...`, `Dividend Cr-...`, GST payment rows.
- Caveat: HF dataset viewer for this repo is broken (`DatasetGenerationError`) — consume files directly, not via the viewer API.

### casparser (CAMS / KFintech / NSDL / CDSL)

- Nature: MIT-licensed Python parser (v1.x, built on pypdfium2) for **original** Consolidated Account Statement PDFs. Not an ML/layout-model system; template/rule-based with strict original-file validation (see gaps).
- Supported issuers/variants (OSS v1.x):
  - CAMS — Detailed and Summary CAS (requested via `mailback.camsonline.com`).
  - KFintech — Detailed and Summary CAS (requested via `mfs.kfintech.com`).
  - NSDL — demat consolidated CAS (monthly email).
  - CDSL — demat consolidated CAS (monthly email).
- CAMS/KFintech (`CASData`) fields: `statement_period`, `file_type`, `cas_type` (DETAILED|SUMMARY), `investor_info` {name, email, address, mobile}, `folios[]` {folio no., AMC, holder name, PAN, KYC/PANKYC status, `schemes[]` {scheme, advisor ARN/RIA, rta_code, rta, type (EQUITY|DEBT|…), ISIN, AMFI, **nominees (names only)**, opening/closing/calculated units, valuation {date, NAV, cost, value}, transactions[] {date, description, amount, units, nav, running balance, typed transaction category, dividend_rate, gift counterparty folio}}}, plus `parse_warnings` (unit-reconciliation failures).
- Typed MF transaction categories: PURCHASE, PURCHASE_SIP, REDEMPTION, SWITCH_IN/OUT (+MERGER), DIVIDEND_PAYOUT/REINVEST, STT/STAMP_DUTY/TDS tax rows, SEGREGATION, GIFT_IN/OUT, REVERSAL, MISC/UNKNOWN.
- NSDL/CDSL (demat) fields: accounts[] {DP name, dp_id, client_id, folio count, total valuation, owners[] with PAN, `equities[]` (ISIN, shares, price, value), `mutual_funds[]` (ISIN, AMFI, units, NAV, avg cost, PnL, UCC/folio), `bonds[]` (ISIN, face value, coupon, maturity, market price)}; `nps` block on CDSL (PRAN, CRA, tier, asset class, units, NAV, value). Demat statements return holdings only, no transactions.
- MF asset classes covered in OSS: mutual funds (folio/demat), equities, bonds, NPS. ISIN/AMFI enrichment via the sibling `casparser-isin` DB. CLI extras: portfolio summary and capital-gains/Schedule 112A CSV.

### CRS "Form 6" (death certificate)

- "CRS" = Civil Registration System run by the Registrar General of India under the RBD Act, 1969; "Form 6" is confirmed as the **Death Certificate**, the extract issued from the death register under Section 12/17 (12 of 13 statutory forms; Form 5 = Birth Certificate, Form 6 = Death Certificate, Form 2 = Death Report, Forms 4/4A = Medical Certificate of Cause of Death for institutional/non-institutional deaths, Form 8 = Death Register).
- Extractable fields per the sample Form-6 (UP) and the form set: registration unit, registration number, registration date, name of deceased, sex, date of birth/age, date and place of death, informant details, issuing registrar. Central-state-portal template with state variants; certificate does not disclose cause of death (RBD Amendment Act 2023 guarantees date/place-only proof; rules revised 1999 → 2019 → 2024).

## Out of reach / unclear

- **ADR 0019 is inaccurate on bank institutions.** The dataset contains no HDFC/SBI/ICICI statement layouts; its banks are fictional and its IFSCs synthetic. "Authentic IFSC" applies only to counterparty codes inside narration text. Institution seeding for HDFC/SBI/ICICI must come from elsewhere (e.g., RBI/IFSC directories), not from this dataset.
- **No personal or savings-account layouts anywhere.** The AgamiAI corpus is business current accounts; estate assets in LegacyLedger are personal account types. Layout grounding is indicative, not representative.
- No dataset or library in this set carries **nomination percentages, joint-holder modes (EITHER_OR_SURVIVOR / JOINTLY), minor-nominee appointees, or claim-workflow documents** — casparser exposes nominee names only. Those will remain owner-declared seed data.
- casparser hard-rejects **re-printed or third-party-reformatted PDFs** (generator metadata/watermark check) and does not support **MF Central** CAS. A fixture pipeline that re-renders CAS-like PDFs will not be parseable by casparser itself; only original issuer PDFs pass. CAS files are password-protected by default (CAMS/NSDL/CDSL = PAN; KFintech = user-defined), so fixtures need a stored test password.
- OSS casparser does **not** parse insurance policies, PPF/EPF, G-Secs/AIFs (the latter only in the commercial casparser.in API). So the deterministic tier's provable asset classes are MF folios, demat equities/MFs/bonds, and NPS.
- CRS Form 6 layout is **state-variant and has changed across rule revisions (1999/2019/2024)**; only one representative sample (UP) was retrieved; the central CRS portal PDF was not fetchable during this session. Pick one canonical sample and freeze it as the fixture reference.
- AgamiAI's HF dataset viewer fails to generate; there is also no per-bank distribution documented in the card — bank-name variety must be sampled from files after download, not from metadata.
- Unverified: exact per-folder statement counts and the full set of fictional bank names (only two sampled). Dataset card scope claims are trusted as stated.

## Seed scope decision and implementation notes

The initial scope decision is recorded in ADR 0035. The asset classes, institution examples, and source-maintenance rule below are accepted. Parser-specific details remain implementation notes.

- Seed the institution directory (HDFC, SBI, ICICI, CAMS/KFintech/NSDL/CDSL as RTAs/depositories) from real RBI/registrar sources; use AgamiAI only for statement **layout, narration grammar, and OCR fixtures** — never as institution evidence.
- Design the deterministic bank-statement parser assertively around the two AgamiAI layouts plus the narration taxonomy (UPI/NEFT/RTGS/IMPS/chq/cash/ATM/charges/reversal), since those tokens are the realistic regex surfaces; treat personal vs current account as a field, not a layout.
- Mirror casparser's `CASData`/`NSDLCASData` JSON shape (folios, schemes, ISIN/AMFI, typed transactions, valuation; demat accounts with dp_id/client_id; NPS block) as the CAS extraction target, but keep nomination percentages, holding mode, and minor/appointee data as owner-declared fields — they cannot be parsed.
- Model the simulated death certificate fixture on CRS Form 6 with only the verifiable fields (registration unit/number/date, name, sex, date and place of death, informant) and deliberately omit cause of death, matching the 2023 amendment behavior.
- Plan the fixture pipeline for password-protected, original-generator PDFs (store test passwords; convert scanned pages for the OCR path); expect casparser to reject re-rendered CAS PDFs if it is ever run directly on fixtures.
