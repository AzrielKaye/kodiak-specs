# 06 — Failure Stories

**Purpose:** Preserve the incident reasoning that code alone cannot show.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Incidents

None verified. The four repositories have no commits, implementation, tests, CI, or incident records. Inventing an outage would teach false history; add the first story only from an issue, log timeline, commit, or postmortem.

Use this structure for the next incident:

### Incident: <short name> (<date>)
**Confidence:** verified | inferred | suspect, with evidence.
**What happened:** observable impact and affected build.
**Why:** technical cause and the condition that allowed it.
**How found:** exact symptom, log, test, or alert.
**Fix:** code/config/process change and retest.
**Lesson:** rule added to 04, 05, 08, 09, 11, or 16.
