# 14 — Developer Workflows

**Purpose:** Safe recipes for common work while the repositories are being bootstrapped.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Inspect before coding

1. Read 00, 01, 04, and the repository `AGENTS.md`.
2. Confirm the target repository and `git status`; preserve unrelated uncommitted files.
3. Find the contract, schema, configuration, and tests; if absent, create the decision/spec first.
4. Update every lockstep owner in 04 and add focused tests (see 11).
5. Record surprises in `INBOX.md`.

## Add a feature

1. Define acceptance behavior and role/privacy rules in specs.
2. Update API/database contract and both clients as applicable.
3. Test denied access, malformed input, retries, and migration compatibility.
4. Run the repository's recorded formatter, lint, type, unit, and integration commands.
5. Review the diff for secrets and stale docs, then use the commit format in [git-guidelines.md](../git-guidelines.md).

## Release

Follow 10 and the promotion rules in [git-guidelines.md](../git-guidelines.md). Tag only the exact published `release` commit; do not push from this handoff task.

End each workflow with: add what surprised you to `INBOX.md`.
