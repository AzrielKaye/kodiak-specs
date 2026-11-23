# 05 — Debugging Playbook

**Purpose:** A short path from an observed symptom to evidence.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Current evidence locations

No application logs, telemetry, CI output, routes, or runtime configuration exist in the workspace. Do not claim a production diagnosis from this repository. Start with the exact client/API error, timestamp, environment, request ID, user role, and build/tag.

## Symptoms and shortcuts

| Exact symptom | Likely causes, in order | Shortcut |
|---|---|---|
| `No implementation exists` | Repository checkout is still bootstrap-only | `rg --files kodiak-api kodiak-android kodiak-web` and inspect Git status/history. Miss → time is wasted debugging a service that cannot run. |
| `Client cannot authenticate` | Unspecified Google Sign-In integration, missing API configuration, expired token, role mapping | Capture provider response without tokens; compare the eventual contract and environment names. Miss → secrets leak into tickets or logs. |
| `Client receives unexpected response` | Contract drift between API and client | Compare route, status, envelope, and field names against the API contract tests. Miss → UI may treat an error as empty data. |
| `Permission denied` | Role mapping or database policy mismatch | Reproduce with a least-privilege test account and inspect policy decisions, never by disabling authorization. Miss → a debugging shortcut becomes a security defect. |

Once services exist, add exact messages and log locations here, with a diagnostic command and a linked failure story.
