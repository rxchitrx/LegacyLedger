# 03: What permission grants actually allow

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

What does a permission grant allow, who grants or revokes it, and when does it end?

**Relevant refs:** CONTEXT.md ("Scoped `Permission` grants are assigned to authorized claimants/nominees"), ADR 0018 (`v_authorized_claimant_assets` joins the `permission` table), ADR 0021 (read access preserved during dispute).

## Resolution

Accepted in [ADR 0031: Claimant Permissions and Shared Documents](../../../docs/adr/0031-claimant-permissions-and-shared-documents.md). The owner controls asset assignments and optional-document access while the estate is active; assignments lock when a release request is filed. The system creates per-claimant, per-asset workflow grants at release. Claimants can view masked asset details, their checklist and guidance, and work only their own workflows. Full linked shared documents are available when required for an assigned claim, even if they contain other assets' information; optional documents can be blocked by the owner. Views and downloads are audited. Access becomes read-only after claim closure and remains read-only after archiving.
