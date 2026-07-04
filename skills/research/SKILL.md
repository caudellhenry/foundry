---
name: research
description: Investigate an unfamiliar external dependency (API, SDK, protocol) against primary sources and cache the findings as a per-sprint research.md in the repo. Use when a task depends on an external the model may know poorly or that changes frequently.
context: fork
agent: general-purpose
---

# research — per-sprint external-knowledge cache

Research rots: stale cached knowledge sends agents off course. Everything you produce is scoped to **this sprint only** and carries an explicit expiry.

## Method

1. Identify the exact questions the implementation will need answered (auth flow, endpoints and shapes, rate limits, error semantics, versioning, gotchas). Do not research beyond them.
2. Use **primary sources only**: official docs, official repos, changelogs. No aggregators, no blog posts unless from the vendor.
3. Verify anything surprising against a second primary page before recording it.
4. Follow the structure in [RESEARCH-FORMAT.md](RESEARCH-FORMAT.md). Every claim gets a source URL. Set `expires:` to the sprint end date (default: 14 days out).
5. Write the file to `research.md` at the repo root (or merge into it if it exists and is unexpired).

## Contract

Return to the caller a summary of **no more than 1,500 tokens**: the questions answered, the two or three most decision-relevant findings, and anything you could NOT verify. Do not return the whole file — it is on disk.
