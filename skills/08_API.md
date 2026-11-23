# 08 — API

**Purpose:** The contract and workflow for the back-end boundary.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

The intended API is described only as communication between Supabase and web/Android clients in [kodiak-api/AGENTS.md](../../kodiak-api/AGENTS.md). There are no routes, auth middleware, validators, response envelopes, error codes, or versioning files to inventory.

## Contract required before implementation

Document each route with method, path/version, auth requirement, role policy, request schema, success status/body, error envelope/codes, pagination, idempotency, and privacy classification. Keep validator, handler, client model, and contract test in the same lockstep change (see 04).

Google Sign-In is a stated requirement in [business-logic-v1.0.md](../business-logic-v1.0.md), but provider configuration and token verification are not implemented. Never accept an unverified client identity. Miss → an attacker can impersonate a user.

## Adding an endpoint

1. Add or revise the specification and authorization rule.
2. Add the validator and handler with a stable error code.
3. Add API contract tests, including denied roles and malformed input.
4. Update web and Android clients together, or record a compatibility window.
5. Run the clean-database and client integration checks before promotion.

No API version is established. Choose one deliberately; silently changing fields breaks old clients.
