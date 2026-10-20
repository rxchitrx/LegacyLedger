# 07: Seed content — institutions, asset classes, claim rules

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** 17 (research: dataset coverage)
**Claimed by:** —

## Question

Which institutions and asset classes does the system ship with, and what claim-rule / checklist content do we seed?

Undecided: the official asset-class taxonomy, the institution list and their contacts, where ProcessRule content comes from, and who maintains it.

**Relevant refs:** ADR 0003 (`process_rule` seeding), ADR 0007 (pre-seeded non-nominee rule sets), ADR 0019 (dataset grounding), ADR 0020 ("institution nodal contacts"), [research/dataset-coverage.md](../research/dataset-coverage.md).

## Resolution

Accepted in [ADR 0035: Source-Backed Seed Content](../../../docs/adr/0035-source-backed-seed-content.md). The first demo covers bank deposits and fixed deposits, mutual funds, demat equities/bonds, and NPS, with examples SBI, HDFC Bank, ICICI Bank, CAMS, KFintech, NSDL, and CDSL. Rules and institution contacts require dated official sources and are maintained in versioned seed data by project maintainers. AgamiAI is only a synthetic parser/OCR fixture; insurance rules are outside the initial seed set.
