# 11 — Testing

**Purpose:** Define honest confidence while the implementation and test system are built.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

There are currently no test files, test runner, coverage report, CI, or executable application. Current coverage is therefore not established; do not report it as zero-percent product coverage without a runner.

Required layers once code exists:

| Layer | Must prove |
|---|---|
| Unit | Validators, role decisions, privacy transformations, error mapping |
| API contract | Status/envelope/fields, auth failures, malformed input, compatibility |
| Database integration | Migrations, constraints, policies, deletion and retention |
| Client integration | Google sign-in, API error states, offline/retry behavior, web/Android parity |
| System/manual | Major product claims from `business-logic-v1.0.md`, including privacy consent and aggregation thresholds |

Every lockstep change in 04 needs a focused test. Include least-privilege, expired token, duplicate/retry, empty data, pagination boundary, migration-from-previous-version, and sensitive-data logging drills. Mock external identity/network failures, but keep at least one real integration path before release; mocks alone can hide contract drift.
