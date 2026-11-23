# 13 — Dependencies

**Purpose:** Explain why dependencies exist and what must be rechecked during upgrades.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

There are no manifests or dependency locks in any repository, so no dependency inventory can be verified. Do not add a framework or SDK merely because it is familiar: record its purpose, supported versions, license, security posture, update owner, and removal cost.

Expected external boundaries requiring explicit choices are Google Sign-In and Supabase. Their SDK/API versions, token verification behavior, generated clients, rate limits, outages, and migration policy are unknown. Miss → an upgrade can change authentication or data semantics without a coordinated client/API release.

For every dependency upgrade, run security review, lockfile diff, unit/contract/integration tests, clean installation, and release smoke tests. Record deliberate rejections so the same unsuitable library is not reconsidered without new evidence.
