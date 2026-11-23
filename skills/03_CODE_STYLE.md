# 03 — Code Style

**Purpose:** Coding and review standards that should apply when implementation begins.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

No formatter, linter, language, framework, logging library, error catalogue, or test command is currently present. The first implementation must record these choices in the relevant repository and update this document; otherwise contributors will format and report errors inconsistently.

Rules:

1. Explain why a surprising guard, workaround, or compatibility branch exists beside the code. A restatement of syntax is noise; deleting the rationale can reintroduce the incident.
2. Use stable names from the approved specification for roles, fields, routes, and errors. Miss → web and Android clients silently diverge.
3. Return errors through one documented API envelope once the API exists, and log a correlation-safe identifier rather than personal or secret data. Miss → clients cannot handle failures consistently and logs become a privacy risk.
4. Add formatter, linter, type checks, and tests to CI when chosen. The command and version must live in repository configuration, not tribal knowledge.
5. Use the commit format in [git-guidelines.md](../git-guidelines.md): `scope: Imperative summary`, 50 characters or fewer, with a reason for non-trivial work.

These are proposed bootstrap rules, not evidence of existing code style.
