# 07 — Database

**Purpose:** Database identity, integrity, migration, deletion, and indexing guidance.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

No migrations, schema files, Supabase project configuration, tables, indexes, policies, or seed data are present. Therefore identity strategy, table map, delete semantics, and query limits are unknown—not safe to infer from the placeholder requirements.

Before the first table ships, decide and record:

1. Which Supabase identity key owns user records and how Google identities map to it. Miss → duplicate accounts or an account takeover during provider changes.
2. Required foreign keys, uniqueness, check constraints, and nullability. Miss → invalid states become permanent data and client code grows defensive branches.
3. Hard versus soft deletion, retention, and location-data minimization. Miss → privacy obligations cannot be honored consistently.
4. Forward-only migrations, rollback/data-repair procedure, and a clean-database test. Miss → a partially applied deployment strands the API between schema versions.
5. Indexes from measured query patterns, including role/tenant and time filters. Miss → list screens become slow as data grows.

Do not run destructive SQL against a shared environment until the target, backup, and recovery path are documented.
