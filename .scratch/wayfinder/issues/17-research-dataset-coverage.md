# 17: Research — dataset coverage (formats, institutions, asset classes)

**Label:** wayfinder:research
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (research — fired during charting)
**Claimed by:** —

## Question

What do the ADR 0019 grounding sources actually cover — the bank statement dataset (which banks, formats, fields) and casparser's CAMS/KFintech CAS support (folio fields, asset classes) — so the seed content (ticket 07) can be scoped to what the deterministic parser tier can realistically handle?

Check ADR 0019 for the exact source list (including any "CRS Form 6" reference).

Deliverable: a coverage summary — what is realistically supported, what is out of reach.

**Findings:** [`../research/dataset-coverage.md`](../research/dataset-coverage.md)

## Resolution

Resolved 2026-10-18 by a research subagent during charting. Key facts: ADR 0019 misstates the bank dataset — `AgamiAI/Indian-Bank-Statements` has no HDFC/SBI/ICICI layouts, only synthetic business current-account statements from fictional banks (with JSON ground truth, two layouts, digital + scanned variants); casparser is a rule-based parser covering CAMS and KFintech CAS plus NSDL/CDSL demat, with nominee names only (no allocation percentages); "CRS Form 6" is verified as the death certificate form (RBD Act extract). Implications flagged for tickets 07 and 13.
