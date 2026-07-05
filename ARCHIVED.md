# ⛔ ARCHIVED — This repo is frozen

> **This repo (`caudellhenry/foundry`) is frozen at v0.1.0.**
> The canonical foundry pipeline now lives at **[caudellhenry/foundry-pipeline](https://github.com/caudellhenry/foundry-pipeline)** (v2.0.0+).

## What happened?

In July 2026, foundry was rebuilt as a **monorepo** at
[`caudellhenry/foundry-pipeline`](https://github.com/caudellhenry/foundry-pipeline):

- **15 portable skills** (ship, grill, research, prototype, prd, tdd, board, implement, qa, diagnose, security-review, handoff, evals, literate-diff, context-rotate)
- **Tracker-flexible**: local markdown / GitHub Issues / Linear via adapter pattern
- **Patch-aware**: detects local divergence from canonical and offers to push upstream
- **Multi-harness install**: Claude Code, Zcode, Hermes, OpenCode, Antigravity, MimoCode, skills.sh
- **Version-numbered**: every `SKILL.md` carries `foundry_version: 2.0.0`
- **Single `VERSION` file** drives every package manifest with a CI guard

This repo (v0.1.0) is preserved for historical reference. **No further updates will land here.**

## What to do

**If you have an existing v0.1.0 install:**

```bash
# 1. Back up any state
cp -r ~/.foundry ~/.foundry.bak.v0.1.0

# 2. Install v2.0.0 (any harness)
# See: https://github.com/caudellhenry/foundry-pipeline/blob/main/docs/INSTALL.md

# 3. Migrate state forward
bash <v2.0.0-install>/packages/core/scripts/foundry-migrate.sh

# 4. Verify
/foundry:status
```

## Migration map

| v0.1.0 | v2.0.0 |
|---|---|
| `/foundry:idea` | `/foundry:grill` |
| `/foundry:prototype` | `/foundry:prototype` (same) |
| `/foundry:prd` | `/foundry:prd` (same) |
| `/foundry:board` | `/foundry:board` (same) |
| `/foundry:implement` | `/foundry:implement` (same) |
| `/foundry:review` | `/foundry:review` (same) |
| `/foundry:qa` | `/foundry:qa` (same) |
| `/foundry:ship` | `/foundry:ship` (same) |
| `state.json` | `state.md` (frontmatter + prose) |
| GitHub Issues MCP only | local / GitHub / Linear via adapter |

See [`docs/MIGRATION.md`](https://github.com/caudellhenry/foundry-pipeline/blob/main/docs/MIGRATION.md) for the full mapping.

## Why was this archived (not deleted)?

To preserve git history for anyone with existing v0.1.0 setups that need to reference the old code. The repo will not be deleted; only new development happens at `caudellhenry/foundry-pipeline`.

---

*Last updated: 2026-07-05 — archived in favour of [caudellhenry/foundry-pipeline v2.0.0](https://github.com/caudellhenry/foundry-pipeline).*