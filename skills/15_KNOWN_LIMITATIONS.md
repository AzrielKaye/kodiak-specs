# 15 — Known Limitations

**Purpose:** Make missing or risky knowledge visible so it is not mistaken for a guarantee.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

Ranked by surprise risk:

1. **No implementation baseline:** all three application repositories have no committed source, manifests, tests, CI, or deploy files. A runnable architecture and release cannot yet be inferred.
2. **Requirements are placeholders:** `business-logic-v1.0.md` contains `<Team Name>`, `<Code Name>`, ellipsis requirements, blank roles, and numbered feature placeholders. Permissions and acceptance criteria are not defined.
3. **No data contract:** schema, migrations, retention, deletion, indexes, and Supabase policies are unknown (see 07).
4. **No API contract:** routes, envelope, validators, versioning, and error codes are unknown (see 08).
5. **No privacy evidence:** the intended privacy principles are stated but not implemented or legally reviewed (see 09).
6. **No verified incidents or performance data:** operational lessons, limits, and alerting are absent (see 05, 06, 12).
7. **Planning output is not present:** `sense-making.md` instructs a CSV at `planning/sense-making.csv`, but that file and its cited research are absent. Do not fabricate it.

Redesign candidates: define the product and contracts first; then choose deployment boundaries and a shared contract-testing strategy. These are proposals, not approved decisions.
