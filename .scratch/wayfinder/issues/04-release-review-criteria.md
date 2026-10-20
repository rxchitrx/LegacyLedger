# 04: Automatic release checks after a claimant files a death certificate

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

What checks must the system perform when a claimant submits a death certificate and before it automatically approves release after the owner's veto window?

Undecided: which certificate fields and consistency checks the system can verify, and how failed or inconclusive checks affect the request.

**Relevant refs:** ADR 0027 (`sp_decide_release_request`), ADR 0030 (claimant-filed request and automatic approval after the veto window).

## Resolution

Accepted in [ADR 0032: Basic Death Certificate Checks](../../../docs/adr/0032-basic-death-certificate-checks.md). The demo checks that a certificate is present and readable and that the deceased person's name matches the owner's recorded name. It does not authenticate the certificate against government records. An unreadable document or name mismatch blocks release until the claimant uploads a corrected certificate; a passing corrected upload starts a fresh owner veto window.
