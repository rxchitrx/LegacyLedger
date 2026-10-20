# 06: Where the timing settings live

**Label:** wayfinder:grilling
**Parent:** [The wayfinder map](../map.md)
**Status:** closed
**Blocked by:** None (can start immediately)
**Claimed by:** —

## Question

Where do the tunable timing values live — veto window, claim-lapse inactivity threshold, stale-asset age — and who can change them?

Undecided: the mechanism (settings table, config file, or environment variables), the admin control surface, the demo-shortened values, and whether changes are audited.

**Relevant refs:** ADR 0027 ("configurable duration (shortened for the demo)"), ADR 0023 ("configured lapse threshold; default 180 days; shortened for demo"), ADR 0011 (hardcodes `INTERVAL '365 days'`).

## Resolution

Accepted in [ADR 0034: Timing Values in Project Configuration](../../../docs/adr/0034-timing-values-in-project-configuration.md). Timing values live only in project/deployment configuration, outside the app UI. Demo defaults are a 2-minute veto window, 180-day claim-inactivity threshold, and 365-day stale-asset warning age. Changing them is a config/deployment change, not an in-app or database-audited action. This does not assign anyone authority to lapse claims; that remains for issue 18.
