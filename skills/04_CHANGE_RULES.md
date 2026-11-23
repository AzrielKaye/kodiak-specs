# 04 — Change Rules

**Purpose:** Lockstep changes that must be updated and retested together.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Known or expected lockstep sets

| Set | Files/owners | Required check |
|---|---|---|
| Product requirements and access | `business-logic-v1.0.md`, API authorization, web routes, Android screens | Verify every user level and feature has an owner and acceptance test. Miss → a UI can expose an unimplemented or unauthorized feature. |
| API contract | API route handlers, validators, response types, web client calls, Android client calls | Contract tests for status, envelope, field names, and auth. Miss → one client interprets a valid response as failure. |
| Data schema | Supabase migrations, API models/validators, client models, seed data | Apply migrations to a clean database and run integrity tests. Miss → deployed clients read missing or differently typed columns. |
| Roles and errors | Shared role constants, database policies, API authorization, client messages | Test allow and deny paths for every role and error code. Miss → privilege escalation or misleading recovery. |
| Release identity | repository history, tags, release bundle, spec release table | Verify tag points to the published commit and follows `SCN/WCN/BCN/ACN.0X.Y.00Z`. Miss → testers validate a different build than the tagged one. |

The first four sets are inferred from the intended ecosystem and must be replaced with exact paths when code exists. The release set is verified in [git-guidelines.md](../git-guidelines.md).

## High-risk review

Treat authentication, authorization, location/privacy data, migrations, deletion behavior, and response fields as high risk. Retest them on every change because a silent mismatch can preserve a green build while changing who can see data.
