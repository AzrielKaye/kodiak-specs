# 01 — Architecture

**Purpose:** The system model and ownership boundaries; read first when joining the project.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Current model

Kodiak is intended to have a web client, Android client, and back-end API backed by Supabase, with shared product specifications. This is the only architecture stated by [kodiak-api/AGENTS.md](../../kodiak-api/AGENTS.md); no implementation exists to verify the data flow.

## Components and boundaries

| Component | Intended ownership | Verified evidence |
|---|---|---|
| `kodiak-web` | Regulatory-compliance web front end | `kodiak-web/AGENTS.md` only |
| `kodiak-android` | Android application | `kodiak-android/AGENTS.md` only |
| `kodiak-api` | Communication between clients and Supabase Database API | `kodiak-api/AGENTS.md` only |
| `kodiak-specs` | Product specifications and release guidance | `kodiak-specs/AGENTS.md` and existing markdown |

Hard boundary: clients must not bypass the API until an explicit design decision says otherwise; otherwise authorization, privacy, and response contracts can drift. This is a proposed guard, not a verified implementation rule.

## Decisions and debt

No accepted decision records, routes, schema, migrations, or commits exist. Highest-ranked debt is defining the system boundary and authoritative data model before implementation; otherwise each client can create incompatible behavior. Next is replacing placeholders in `business-logic-v1.0.md`; otherwise permissions and requirements cannot be tested.

No failure story is reconstructed because there is no incident history or implementation to inspect.
