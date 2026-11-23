# 09 — Security

**Purpose:** Security model and change checklist for a privacy-sensitive ecosystem.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Threat model

Protect Google identities, authorization decisions, Supabase data, location data, and operational secrets from unauthenticated users, compromised clients, malicious insiders, and accidental log exposure. The business-logic placeholder explicitly calls for Data Privacy Act compliance, location protection, retention limits, no per-user trails, aggregation thresholds, and consent for resale; implementation evidence is absent.

Authentication must verify Google tokens server-side. Authorization must be enforced at the API and database policy layers, not only in web/Android controls. Miss → a forged request or direct database path bypasses the UI.

Name environment variables in documentation but never values. Do not commit service-role keys, OAuth secrets, tokens, personal data, or real location samples. Miss → credential compromise or an avoidable privacy breach.

## Change checklist

- Identify data collected, purpose, retention, and deletion behavior.
- Test unauthenticated, wrong-role, cross-user, and malformed requests.
- Review injection surfaces: query filters, search, serialization, redirects, file uploads, and logs.
- Keep debug endpoints and verbose errors disabled outside local development.
- Verify rate limits, token expiry/revocation, secure transport, and secret rotation once configured.
- Record accepted gaps in 15 and link the decision.
