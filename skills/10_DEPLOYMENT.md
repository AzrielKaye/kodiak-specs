# 10 — Deployment

**Purpose:** Promote the four repositories through controlled development, testing, and approval gates.

**Confidence note:** verified against [git-guidelines.md](../git-guidelines.md) and the workspace snapshot on 2026-11-23. The code wins (see 16).

## Release order

The exact dependency order is not yet proven. Establish it with a deployable integration test; the API/database contract normally gates clients. Do not publish a client against an unverified API or migration.

The required maturity path is `main → beta → release → production`: developers unit-test on `main`, QA system-tests on `beta`, independent testers test only a published bundle from `release`, and a designated approver separately approves production. Miss → unreleased development code is mistaken for a tested release.

## Checklist

1. Confirm planned development is complete and the build is reproducible.
2. Promote reviewed changes through each gate; carry fixes back upstream when required.
3. Apply/verify database migrations and configuration with no secrets in artifacts.
4. Publish the exact release bundle and record its commit, tag, environment, and checks.
5. Use `a`, `b`, and `rc` candidate labels and increment iterations for defects.
6. Deploy only the exact approved RC; never move or reuse a tag.

No deploy manifests, hosting target, CI workflow, environment inventory, or rollback procedure exists yet. Add each to this document when verified.
