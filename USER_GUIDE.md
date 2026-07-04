# Foundry — User Guide

> The complete AI-engineering shipping workflow, in one slash command.

`/foundry` (alias `$foundry`) runs a **seven-phase pipeline** that takes you from a vague idea to a shipped, tested, QA-signed feature — with **real test execution** and **fresh-context sub-agents** doing the heavy lifting.

---

## 🚀 Quick start (60 seconds)

```bash
cd /path/to/your/project
/foundry "ship: add Stripe-backed subscriptions to the SaaS"
/foundry-status                       # see where you are
/foundry-loop-on                      # (optional) go AFK on Dev/QA
/foundry-signoff                      # when 8/8 gates are green
```

That's it. Everything else (board, TDD specs, evidence, sub-agents, tests) is managed for you.

---

## 🧭 The seven-phase flow

```
                          ┌────────────────────────────┐
                          │  1. IDEA  (grill-me)       │   sharpen the intent
                          └─────────────┬──────────────┘
                                        │  intent + risks
                                        ▼
                          ┌────────────────────────────┐
                          │  2. RESEARCH  (optional)   │   ground it in facts
                          └─────────────┬──────────────┘
                                        │  research notes (with expiry)
                                        ▼
                          ┌────────────────────────────┐
                          │  3. PROTOTYPE  (optional)  │   tracer-bullet code
                          └─────────────┬──────────────┘
                                        │  prototype notes
                                        ▼
                          ┌────────────────────────────┐
                          │  4. PRD                    │   destination doc
                          └─────────────┬──────────────┘
                                        │  prd.md
                                        ▼
                          ┌────────────────────────────┐
                          │  5. PLAN / Kanban          │   features + board + stories
                          └─────────────┬──────────────┘
                                        │  board.md + stories
                                        ▼
              ┌─────────────────────────────────────────────────┐
              │   6. EXECUTE  (Ralph loop)                      │
              │     ↺ writer sub-agent per ticket (fresh ctx)   │
              │     ↺ real test runner (jest|pytest|go|cargo)  │
              │     ↺ worktree isolation per ticket             │
              └─────────────────────┬───────────────────────────┘
                                    │  commit + evidence
                                    ▼
              ┌─────────────────────────────────────────────────┐
              │   7. QA  (8-gate convergence)                  │
              │     ↺ per-ticket reviewer (Explore / lite)      │
              │     ↺ cross-ticket reviewer (Explore / lite)    │
              │     ↺ QA planner (general-purpose / sonnet)     │
              │     ↺ 8-gate machine-checkable verdict          │
              │     ↺ /foundry-signoff  (gate 8)                │
              └─────────────────────┬───────────────────────────┘
                                    │  NEW-### findings loop back
                                    ▼  to Phase 6
                            (loop until converged + signed off)
```

**Conditional phases** (2, 3) auto-skip when not needed. **Looping phases** (6, 7) iterate until convergence.

---

## 🎯 The mental model

Foundry is built on three ideas, repeated at every scale:

| Idea | One-liner |
|------|-----------|
| **Spec first** | The PRD is the contract. TDD specs are frozen before code. Code is a translation of the spec. |
| **Fresh context per unit of work** | Each ticket gets a brand-new sub-agent. No context rot, no failure bias. |
| **Convergent loop** | Tests + reviewers + 8-gate check + your sign-off. The loop only exits when the work is real. |

If you remember nothing else, remember: **intent → spec → fresh sub-agent → real test → sign-off**.

---

## 🛠 Install

Foundry is already installed as part of the workspace. If you ever need to set it up fresh:

```bash
# Symlink into the ZCode plugin cache (recommended)
PLUGIN_SRC="/Users/henrycaudell/Agents Workspace/Skills/foundry-pipeline-plugin"
PLUGIN_DST="$HOME/.zcode/cli/plugins/cache/foundry-pipeline-plugin/1.0.0"
mkdir -p "$(dirname "$PLUGIN_DST")"
ln -sfn "$PLUGIN_SRC" "$PLUGIN_DST"

# Shell alias for $foundry
echo "alias \$foundry='/foundry'" >> ~/.zshrc
```

Then restart your session. Verify with `/foundry-status`.

---

## 📋 Slash command reference (18 commands)

### Lifecycle

| Command | What it does |
|---------|--------------|
| `/foundry "<intent>"` | Bootstrap `.foundry/` + start Phase 1 (auto-detects your test runner) |
| `/foundry-status` | One-page summary: phase, board, test config, 8-gate convergence |
| `/foundry-reset` | Reset state (keeps templates; clears test config + signoff) |
| `/foundry-signoff [--by=<name>]` | Mark pipeline as user-signed-off (**gate 8**) |

### Phase entry points (jump straight to a phase)

| Command | Phase |
|---------|-------|
| `/foundry-idea` | 1 — Idea / grill-me |
| `/foundry-research` | 2 — Research |
| `/foundry-prototype` | 3 — Prototype |
| `/foundry-prd` | 4 — PRD |
| `/foundry-plan` | 5 — Plan / Kanban |
| `/foundry-execute` | 6 — Execution loop (Ralph) |
| `/foundry-qa` | 7 — QA |

### Loop control

| Command | What it does |
|---------|--------------|
| `/foundry-loop-on` | Enable auto-loop on Phases 6/7 (validates test config first) |
| `/foundry-loop-off` | Pause auto-loop (you drive manually) |

### Configuration

| Command | What it does |
|---------|--------------|
| `/foundry-test-config [<key> <value>]` | View or edit the test runner config (e.g. `runner jest`, `cmd npx jest`) |
| `/foundry-test-config --auto-detect` | Re-run auto-detection from `package.json`/`pyproject.toml`/`go.mod` |
| `/foundry-set-coverage-baseline` | Set the current coverage as the new baseline |
| `/foundry-parallel-on [max_workers=3]` | Enable parallel fan-out (FR-009) for independent tickets |
| `/foundry-approve-review <TICKET>` | Mark a per-ticket review as `human_approved` (**gate 2**) |

### Cross-cutting

| Command | What it does |
|---------|--------------|
| `/foundry-eval [scenario]` | Run the agent-eval harness against a YAML scenario |
| `/foundry-literate-diff [hash]` | Generate a literate explanation of a commit |
| `/foundry-self-improve [--since YYYY-MM-DD] [--commit]` | Run the skill-improver meta-skill |

---

## 🪜 Step-by-step: a real workflow

### Step 1 — Start the pipeline

```bash
cd ~/code/my-saas
/foundry "ship: add Stripe-backed subscriptions to the SaaS"
```

What happens behind the scenes:

1. `.foundry/` is created.
2. Your test runner is **auto-detected** (jest / vitest / pytest / go-test / cargo-test) and saved to `state.md`.
3. `.foundry/idea/intent.md` is written with your statement.
4. **Phase 1 (Idea)** begins.

### Step 2 — Phase 1: Idea (grill-me)

The agent interrogates your intent with sharp questions. Goal: turn *"I want X"* into a *testable* intent.

Outputs:
- `.foundry/idea/intent.md` — the sharpened intent
- `.foundry/idea/risks.md` — known risks, unknowns, and out-of-scope items

When you're both happy, the phase auto-advances (or you say "next").

### Step 3 — Phase 2: Research (conditional)

If the agent suspects you'll benefit from research (external APIs, unfamiliar tech), it gathers it. Otherwise this phase is **skipped** automatically.

Output: `.foundry/research/research.md` (with an expiry date — research rots).

### Step 4 — Phase 3: Prototype (optional)

A **tracer-bullet** slice that proves the riskiest path through the system end-to-end. Thrown away after — its purpose is to de-risk, not to ship.

Output: `.foundry/prototype/notes.md` + a small code spike.

### Step 5 — Phase 4: PRD

The destination doc. Written as if the feature already shipped, in user-facing language. Becomes the **source of truth** for everything downstream.

Output: `.foundry/prd.md`

### Step 6 — Phase 5: Plan / Kanban

Three artefacts:

| File | What |
|------|------|
| `.foundry/plan/features.md` | Parent features (high-level capabilities) |
| `.foundry/plan/board.md` | The kanban board — `Ready` / `In progress` / `Review` / `Done` / `Blocked` |
| `.foundry/plan/stories/<STORY>.md` | One user-story per ticket |

**TDD specs are frozen here.** The next phase treats them as a contract.

### Step 7 — Phase 6: Execute (the Ralph loop)

This is where the work happens. For each ticket:

```
1. Pick next ticket from board (priority + oldest)
2. Spawn fresh writer sub-agent (general-purpose / sonnet)
3. Writer runs TDD: red → green → refactor
4. Writer records evidence + commits
5. Real test runner runs (jest|pytest|go-test|cargo-test)
6. Move ticket to Review (or Done)
7. Loop back to step 1
```

**Why sub-agents?** Fresh context prevents *anterograde-amnesia drift* (Karpathy) — the writer doesn't carry the previous ticket's biases forward.

**Worktree isolation (v1.3.0):** Each writer works in its own git worktree on branch `feat/<TICKET>`. After it succeeds, the orchestrator merges to main and cleans up. No clobbering, clean per-ticket history.

**Parallel fan-out (v1.3.0):** If `/foundry-parallel-on` is enabled, up to `max_workers` independent tickets run concurrently. Default: 3.

Go AFK with `/foundry-loop-on`. Resume manually with `/foundry-loop-off`.

### Step 8 — Phase 7: QA (8-gate convergence)

For each QA round:

```
1. Per-ticket reviewer (Explore / lite) — fresh context per ticket
   → looks for cognitive debt, comprehension debt, security, perf, a11y
2. Cross-ticket reviewer (Explore / lite) — once per round
   → orphaned code, dead exports, pattern drift
3. QA planner (general-purpose / sonnet) — fresh context
   → synthesises all findings into qa-plan.md
4. 8-gate convergence check (machine-checkable)
5. Loop back to step 1 if any gate fails (except gate 8)
```

#### The 8 convergence gates

| # | Gate | Pass condition |
|---|------|----------------|
| 1 | Board empty | Ready + In progress = 0 |
| 2 | Review empty | Every Review ticket has `human_approved: true` |
| 3 | No high findings | `qa-plan.md findings.high == 0` |
| 4 | No medium findings | `qa-plan.md findings.medium == 0` |
| 5 | Tests pass | Latest runner JSON has `failed == 0` |
| 6 | Coverage gate | `coverage_pct >= threshold` AND `>= baseline - 2%` |
| 7 | Lint + typecheck | Both have 0 errors |
| 8 | User signoff | `/foundry-signoff` has been run |

**Failure routing:**
- Gates 1–2 fail → loop back to Phase 6 to clear the board.
- Gates 3–7 fail → writer sub-agent fixes, then re-checks.
- Gate 8 fails → you run `/foundry-signoff` to acknowledge.

### Step 9 — Ship

When all 8 gates are green and you've signed off, the pipeline is **complete**. Your feature is real, tested, and reviewed.

---

## 🗂 Where everything lives

```
.foundry/
├── state.md                    # master state (frontmatter + phases + board)
├── idea/                       # Phase 1
│   ├── intent.md
│   └── risks.md
├── research/                   # Phase 2 (with expiry)
│   └── research.md
├── prototype/                  # Phase 3
│   └── notes.md
├── prd.md                      # Phase 4
├── plan/                       # Phase 5
│   ├── features.md
│   ├── board.md
│   └── stories/                # one .md per ticket
├── tdd/                        # Phase 6 (one per ticket)
│   └── <TICKET>.md             # red/green/refactor notes
├── qa/                         # Phase 7
│   ├── qa-plan.md              # per round, machine-checkable
│   ├── evidence/<TICKET>.md    # per-ticket evidence
│   └── review/<TICKET>.md      # per-ticket reviewer output
├── literate/<commit>.md        # literate diffs
├── eval/                       # agent-eval
│   ├── scenarios/<name>.yaml
│   └── results/<ts>-<name>.json
└── logs/                       # tool-call + session + hook logs
```

**Local-first**: no Linear, no GitHub Issues, no Notion required. The board schema is compatible with both Linear and GitHub for future MCP integration.

---

## 🤖 Sub-agent matrix

| Role | Profile | Model | Spawned | Output |
|------|---------|-------|---------|--------|
| Writer (per ticket) | `general-purpose` | sonnet | per ticket | `.foundry/tdd/<T>.md` |
| Reviewer (per ticket) | `Explore` | lite | per ticket | `.foundry/qa/review/<T>.md` |
| Cross-reviewer (per round) | `Explore` | lite | once per round | `.foundry/qa/review/CROSS-round-<N>.md` |
| QA planner (per round) | `general-purpose` | sonnet | once per round | `.foundry/qa/qa-plan.md` |

**Why a lower-power model for review?** Because a fresh, simpler reviewer is less likely to share the writer's biases. (Anthropic's writer/reviewer pattern, via Willison: *"use your judgement to decide an appropriate lower power model."*)

---

## 🪝 Hook chain (the invisible plumbing)

| Event | Hook | Purpose |
|-------|------|---------|
| `SessionStart` | `session-start.sh` | Bootstrap `.foundry/`, stamp session id, surface phase |
| `UserPromptSubmit` | `user-prompt-submit.sh` | Log the prompt, surface current phase |
| `PreToolUse` (Bash/Write/Edit) | `pre-tool-use.sh` | Non-blocking scope guardrails (no `rm -rf /`, no `sudo`) |
| `PostToolUse` | `post-tool-use.sh` | Log tool call, recommend context rotation, stage literate-diff fragments |
| `Stop` | `stop-hook.sh` | **The Ralph loop driver** — verify phase, advance, or block exit to keep looping |

The `Stop` hook is the most important. When `auto_loop: true`, it:
1. Runs `scripts/verify.sh <phase>`.
2. If PASS, advances the phase and re-feeds the focus prompt.
3. For Phases 6/7, loops *within* the phase (one ticket per iteration) up to `DEV_PIPELINE_MAX_ITER` (default 50).
4. For other phases, blocks exit until you sign off (or the verifier passes).

---

## 🛟 Common workflows

### I want to pause and resume later

```bash
/foundry-loop-off                  # stop the auto-loop
# ... take a break ...
/foundry-loop-on                   # resume
/foundry-status                    # see where you are
```

### One ticket is stuck in review

```bash
/foundry-approve-review STORY-007  # mark it approved (gate 2)
/foundry-qa                        # re-run convergence check
```

### I want to add a new ticket mid-flight

1. Add it to `.foundry/plan/board.md` under `## Ready`.
2. Add a story at `.foundry/plan/stories/<TICKET>.md`.
3. Run `/foundry-execute`.

### I want to ship in parallel

```bash
/foundry-parallel-on 4             # up to 4 workers
/foundry-loop-on
```

Each worker gets its own worktree on `feat/<TICKET>`. Results merge serially after all complete.

### I want to inspect a specific commit

```bash
/foundry-literate-diff <hash>      # generates a literate diff in .foundry/literate/
```

### I want to evaluate the agents

```bash
/foundry-eval example-add-a-button # runs .foundry/eval/scenarios/*.yaml
```

---

## 🧯 Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `/foundry` says "no test runner detected" | No `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` | Run `/foundry-test-config runner vitest cmd "npx vitest run"` |
| Auto-loop won't enable | Test config is incomplete or stale | Run `/foundry-test-config --auto-detect` |
| Coverage gate keeps failing | New code isn't covered | Writer sub-agent will be re-fed to add tests; or run `/foundry-set-coverage-baseline` to relax the baseline |
| `ITERATION_CAP HALT` in stop output | 3+ consecutive failures on the same failure_id (arXiv 2506.11022) | Review the failure, then `/foundry-signoff` to clear the cap |
| Gate 8 won't go green | You haven't signed off | Run `/foundry-signoff --by="Your Name"` |
| Board won't drain | Review tickets need `human_approved` | Run `/foundry-approve-review <TICKET>` for each |
| Writer sub-agents keep trampling each other | Worktrees disabled | `foundry-state.sh set-worktree enabled` (default since v1.3.0) |

---

## ⚙️ Environment variables

| Var | Default | Meaning |
|-----|---------|---------|
| `DEV_PIPELINE_PROJECT_ROOT` | `$(pwd)` | Where `.foundry/` lives |
| `DEV_PIPELINE_MAX_ITER` | `50` | Max Dev/QA loop iterations |
| `FOUNDRY_ITER_CAP` | `3` | Consecutive-failure cap (security) |

---

## 🧠 Principles (read once, internalise forever)

1. **Specs are contracts.** The PRD is the destination. TDD specs are frozen before code. Code is a translation.
2. **Fresh context beats long context.** A new sub-agent with a tight prompt is sharper than a long-running one with drift.
3. **Real tests beat file existence.** Foundry runs your actual `npm test` / `pytest` / `go test` and parses pass/fail/coverage.
4. **Convergence is machine-checkable.** The 8 gates are not vibes. They are greps and JSON keys.
5. **Sign-off is the last gate.** You ship when you say you ship.

---

## 📚 Where to go next

- **`README.md`** — the technical reference (full command list, file layouts, hook chain details)
- **`INSTALL.md`** — install / upgrade / uninstall procedures
- **`CHECKLIST.md`** — production-readiness checklist for the plugin itself
- **The design source** — `Knowledge Base/analysis/analysis_ai-engineering-practices-deep-research_2026-07-03.md`

---

*Foundry v1.2.0 — real test runner, fresh-context sub-agents, 8-gate convergence.* 
*Foundry v1.3.0 — worktree isolation + parallel fan-out (FR-008, FR-009).*
