# 11: Document download consent — record or flag

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

Is the owner's consent for claimant document downloads a separate consent record or a simple on/off flag?

Undecided: the mechanism, the default value, and whether consent is revocable with an audit trail.

**Relevant refs:** ADR 0008 ("a `consent` record or flag (`allow_claimant_document_download = TRUE/FALSE`, defaulting to TRUE)").

## Resolution

Accepted in [ADR 0039: Optional Document Access Flag](../../../docs/adr/0039-optional-document-access-flag.md). Optional document access uses a per-claimant/document Boolean preference defaulting to allowed. The owner may change it while the estate is active; required documents remain available. Preference changes, views, and downloads are audited.
