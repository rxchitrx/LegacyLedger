# 19: Testamentary documents and intended beneficiaries

**Label:** wayfinder:issue
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Claimed by:** Codex
**Blocked by:** none

## Question

How should LegacyLedger handle wills and other testamentary documents that name intended beneficiaries?

## Resolution

Store testamentary documents as supporting evidence and allow the owner to associate them with relevant assets. A claimant can view and download a will when it is relevant to an assigned claim, following the required-document access rules in ADR 0031. The app may record a person named as an intended beneficiary, but must not determine legal validity, interpret a will, or allocate assets based on it. Any legal effect and institutional requirements remain for the relevant institution or qualified legal process to determine.

See ADR 0045.
