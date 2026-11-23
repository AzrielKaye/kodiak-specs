# 02 — Project Structure

**Purpose:** Where product code, specifications, and future operational files belong.

**Confidence note:** verified against the workspace snapshot (no repository commits) on 2026-11-23. The code wins (see 16).

## Current tree

```text
kodiak-ecosystem/
├── kodiak-api/       # back-end API; currently only AGENTS.md
├── kodiak-android/   # Android client; currently only AGENTS.md
├── kodiak-web/       # web client; currently only AGENTS.md
└── kodiak-specs/     # specifications, git guidance, planning, skills/
```

Put API code only in `kodiak-api`, Android code only in `kodiak-android`, web code only in `kodiak-web`, and cross-component contracts or decisions in `kodiak-specs`. Do not place implementation in `kodiak-specs/skills/`; those files teach contributors and are not runtime contracts. Miss → tools or deploy packaging can omit the code or mistake guidance for executable product behavior.

Use the repository's framework-standard layout once a framework is selected. Until then, do not invent `src`, `app`, or module names as if they were established conventions. Name skills `NN_TOPIC.md` and append new principles rather than renumbering them.
