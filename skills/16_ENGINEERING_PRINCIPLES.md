# 16 — Engineering Principles

**Purpose:** Short, quotable rules distilled from verified evidence and explicit gaps.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

1. **Do not turn a placeholder into a promise.** The requirements document contains ellipses and template values; inventing behavior makes clients and tests validate fiction. Source: `business-logic-v1.0.md`.
2. **A contract change is a multi-repository change.** Web, Android, API, and database behavior are intended to interoperate; updating one owner silently breaks another. Source: `kodiak-api/AGENTS.md` and 04.
3. **Privacy is a boundary, not a UI option.** The stated solution layer includes location protection, retention limits, aggregation thresholds, and consent; enforcing it only in a client can be bypassed. Source: `business-logic-v1.0.md` and 09.
4. **Unknown is a valid engineering result.** There are no commits or runtime artifacts to support architecture, incidents, performance, or coverage claims; false certainty teaches the wrong fix. Source: repository inspection on 2026-11-23.
5. **Release the tested thing.** The release branch and tag must identify the exact published candidate; otherwise approval can apply to a different commit. Source: `git-guidelines.md`.

Trust the code over any document, including this one.
