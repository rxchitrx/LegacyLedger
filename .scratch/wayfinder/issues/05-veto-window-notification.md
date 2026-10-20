# 05: How the owner actually receives the veto-window alert

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

When a release is filed, how does the owner actually receive the veto-window alert?

Undecided: the channel (in-app banner, email, or simply displayed when they next log in), any timing or retry behavior, and what the demo shows for this safety-critical alert.

**Relevant refs:** CONTEXT.md ("A notification and Veto Window start for the Owner"), ADR 0027 ("a forged certificate could be approved before the owner ever sees the alert").

## Resolution

Accepted in [ADR 0033: Simulated Veto-Window Notifications](../../../docs/adr/0033-simulated-veto-window-notifications.md). When a valid release request starts the veto window, the demo creates an in-app alert plus simulated email and WhatsApp delivery records immediately. The in-app alert persists until the owner opens it or acts. External messages and retries are not performed; simulated channels must be labeled clearly.
