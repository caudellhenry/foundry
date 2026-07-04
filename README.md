# foundry

**Idea → production, as one installable Claude Code plugin.**

`/foundry:ship <idea>` drives the full delivery pipeline — Idea → [Research] → [Prototype] → PRD → Board → Execution → QA — with vertical-slice tickets, executable acceptance checks, deterministic guardrails, and non-negotiable human gates. Built directly on Anthropic's published AI engineering guidance (Claude Code best practices, Building Effective Agents, context engineering, tool design, evals) and the practitioner synthesis in the companion research guide.

Full design rationale and compliance matrix: `Knowledge Base/research/research_ai-engineering-guide_2026-07-04.md`, §9. User guide: [docs/user-guide.html](docs/user-guide.html) ([live mirror](https://plush-laurel-nh4p.here.now/) · markdown source: [USER_GUIDE.md](USER_GUIDE.md)).

## What's portable and what isn't

foundry is two layers, and the directory split *is* the portability boundary — nothing was hidden or bundled together:

| Layer | Where | Standard | Works on |
|---|---|---|---|
| **Skills** (the actual pipeline logic) | `skills/*/SKILL.md` | open [Agent Skills standard](https://agentskills.io) | any harness that reads SKILL.md: Claude Code, Cursor, Codex, Windsurf, Cline, Gemini CLI, OpenCode, and this repo's own Hermes/OpenCode exports below |
| **Guardrails** (hooks, worktree-isolated subagents, plugin manifest) | `hooks/`, `agents/`, `.claude-plugin/` | Claude Code proprietary extensions | Claude Code only |

On a harness without the guardrail layer, the pipeline still runs — the skill text itself tells the agent not to push to main, to cap fix iterations at three, to run TDD, and so on. What you lose is *enforcement*: those become instructions the agent should follow rather than commands a hook makes it follow. `.mcp.json` (GitHub/Linear) uses the Model Context Protocol, which is cross-vendor, but exact client wiring varies — check your harness's MCP docs.

## Install — Claude Code (full guardrails)

```bash
claude
/plugin marketplace add caudellhenry/foundry
/plugin install foundry@foundry-marketplace
```

Local dev install instead of the GitHub marketplace: `/plugin marketplace add /path/to/foundry` (no spaces in the path — symlink around one if needed) then `/plugin install foundry@foundry-marketplace`.

## Install — any Agent Skills-compatible harness (Cursor, Codex, Windsurf, Gemini CLI, …)

```bash
npx skills add caudellhenry/foundry
```

This is the same `skills.sh` distribution mechanism [mattpocock/skills](https://github.com/mattpocock/skills) uses — it scans `skills/` in the repo, lets you pick which of the 14 to install, and asks which agent(s) to target. You get the pipeline logic; you do not get the Claude Code hooks or worktree-isolated subagents (see the table above).

## Install — Hermes / OpenCode (or any tool-agnostic `.agents/skills/` consumer)

Both Hermes and OpenCode on this machine resolve skills through a single shared pool at `~/.agents/skills/`, then symlink into their own skill directories. foundry's skill *names* collide with several of Matt Pocock's originals already in that pool (`research`, `prototype`, `implement`, `tdd`, `qa`, `handoff`), so the export below namespaces every foundry skill as `foundry-<name>` to avoid clobbering anything:

```bash
git clone https://github.com/caudellhenry/foundry.git
cd foundry && bash scripts/export-to-agents-pool.sh
```

This copies each `skills/<name>/` into `~/.agents/skills/foundry-<name>/`, rewrites the `name:` frontmatter line to match, and symlinks `foundry-<name>` into `~/.hermes/skills/` and `~/.opencode/skills/` if those directories exist — mirroring the pattern those tools already use for every other installed skill. Re-run it after pulling updates.

## Install — MimoCode, MiniMax, or anything else

Not verified: neither MimoCode nor MiniMax's coding-agent runtime is present on the machine this repo was built on, so their exact skill-discovery mechanics (directory location, required manifest shape, whether they read the open Agent Skills standard at all) haven't been checked against a real install. If your harness reads `SKILL.md` + YAML frontmatter (`name`, `description`) from a scanned directory, copying any `skills/<name>/` folder in should work as-is — treat the Claude Code-specific frontmatter keys (`disable-model-invocation`, `context: fork`, `agent:`) as safe to ignore if unrecognised. If it doesn't, open an issue with what its skill format actually looks like and this section will get real instructions instead of a caveat.

## The pipeline

| Phase | Skill | Gate |
|---|---|---|
| 1 Idea | `/foundry:grill` | decision tree resolved |
| 2 Research (conditional) | `foundry:research` | research.md with expiry |
| 3 Prototype (conditional) | `foundry:prototype` | human picks the winner |
| 4 PRD | `/foundry:prd` | **human approves the PRD** |
| 5 Board | `/foundry:board` | vertical slices + blocking |
| 6 Execution | `/foundry:implement` (+ `tdd`, `diagnose`) | acceptance check passes (Stop-hook enforced) |
| 7 QA | `/foundry:review` → `/foundry:qa` | **human walkthrough + comprehension quiz** |

`/foundry:ship` orchestrates and tracks state in `.foundry/state.json`. Cross-cutting: `/foundry:security-review`, `/foundry:evals`, `/foundry:handoff`.

## What the hooks enforce (deterministically)

- No pushes to main/master, no force-pushes, no curl-pipe-sh, no rm -rf on root/home
- Turn cannot end while the active ticket's acceptance check fails (`test-gate`, 8-block override applies)
- Formatting on every edit (best-effort, never blocks)
- Session start injects pipeline state and warns on expired research

## Safety properties

- PR-only delivery; small revertable commits
- Max 3 consecutive LLM-only fix iterations before mandatory human review
- Lethal-trifecta audit before any new tool/MCP server
- All orchestrator skills are user-invoked only (`disable-model-invocation: true`)
- Nothing load-bearing lives in a conversation: intent.md, research.md, PRD.md, the board, and state.json are the memory

## Layout

```
.claude-plugin/plugin.json   Claude Code manifest (proprietary)
skills/                      14 skills — the portable core (open Agent Skills standard)
agents/                      Claude Code subagents: explorer · planner · implementer (worktree) · verifier · reviewer
hooks/                       Claude Code guardrail hooks: hooks.json + 6 scripts
scripts/                     export-to-agents-pool.sh — Hermes/OpenCode local install
.mcp.json                    github + linear (MCP; cross-vendor protocol, client wiring varies)
docs/user-guide.html         interactive user guide (Claude Code-oriented; portability notes included)
LICENSE                      MIT
```

## Status

v0.1.0 — core pipeline complete and installable on Claude Code, any skills.sh-compatible harness, and (via the export script) Hermes/OpenCode on this machine. Roadmap (per the research guide §9.10): v0.2 hardening of review/QA loops · v0.3 AFK fan-out script + `.worktreeinclude` template · v0.4 guardrail eval suite in CI · v1.0 wider harness verification (MimoCode, MiniMax, others on request). MIT-licensed: adapt freely; every skill is plain text — read before you run, on this repo or any other.
