# 13: DPDP — retention and erasure vs permanent records

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** 16 (research: DPDP obligations)
**Claimed by:** —

## Question

How do personal-data retention and erasure requests work under DPDP when the system never deletes records?

Undecided: retention periods (including the MongoDB `extraction_candidates` lifecycle), how erasure/correction requests are answered (mask, annotate, or refuse citing lawful basis), and which exemptions cover legal/regulatory retention.

**Relevant refs:** ADR 0002 / 0008 (DPDP framing), ADR 0004 / 0015 / 0028 (immutability), ADR 0001 (extraction candidates live in MongoDB), [research/dpdp-obligations.md](../research/dpdp-obligations.md).

## Resolution

Accepted in [ADR 0041: Purpose-Based Personal Data Retention and Erasure](../../../docs/adr/0041-purpose-based-personal-data-retention.md). Use purpose-based retention without inventing a universal duration; delete extraction candidates after review; allow data subjects to request correction/erasure; retain personal data only for an active purpose or documented legal/claim basis; keep audit events free of raw content and unnecessary personal data. See the ADR for official Act and commencement sources.
