# 12 — Performance

**Purpose:** Record limits, hot paths, and evidence-based optimization decisions.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

No runtime, endpoint, query, device target, dataset, benchmark, or profile exists. There are no verified hot paths or deliberate inefficiencies to preserve. Do not invent latency or throughput targets; establish them from product requirements and representative data.

Measure before changing: API latency by route and status, database query plans, payload size, client startup/render time, offline synchronization cost, and memory on supported Android devices. Record environment, dataset, percentile, and build. Miss → a benchmark cannot be reproduced and an optimization may trade correctness or privacy for an unproven gain.

Keep pagination bounded, avoid unneeded personal/location fields, and prefer indexed queries after schema evidence exists. These are guardrails, not current implementation facts.
