---
name: implement
description: Execute the next unblocked ticket (or a named ticket) through Explore → Plan → Implement → Commit with TDD and an executable acceptance check, on a branch, ending in a PR. Use during the execution phase; supports sequential, parallel (worktrees), and AFK operation.
disable-model-invocation: true
---

# /implement — the execution loop

One ticket at a time, each behind an executable check. Autonomy here was earned by phases 1–5; do not spend it loosely.

## Per-ticket loop

1. **Claim.** Take the named ticket, or the next unblocked one from the board. Record it in `.foundry/state.json` (`ticket`, `check_command` from the ticket's acceptance check, `gate_active: true`).
2. **Explore.** Use the `foundry-explorer` subagent (read-only) to map the relevant code. Never explore by loading whole files into this context — summaries only.
3. **Plan.** Use the `foundry-planner` subagent for a step plan and risk list. **Skip this step when the ticket describes a one-sentence diff.** For anything that changes multiple files or an unfamiliar area, show the plan to the user unless running AFK.
4. **Implement** on a branch named after the ticket, under the `tdd` skill (red–green–refactor, one behaviour at a time). The ticket's check is your goal condition; the Stop-hook test-gate will block turn-end while it fails.
5. **Iteration cap (security).** After **3** consecutive fix attempts on the same failing check without human input, STOP. Post a diagnosis and request human review; reset `iteration_chain` only after that review. (Unreviewed iterative 'improvement' measurably increases vulnerabilities.)
6. **Verify.** Run the full check plus the test suite. For non-executable criteria, use the `foundry-verifier` subagent — it is adversarial and tries to make the check fail.
7. **Commit and PR.** Small revertable commits referencing the ticket; open a PR; never push to main. Set `gate_active: false`, clear `ticket`, tick the ticket done on the board.

## Parallel and AFK modes

- **Parallel:** fan `foundry-implementer` subagents (worktree-isolated) across genuinely unblocked tickets; edits never collide.
- **AFK (Ralph loop):** emit `scripts/foundry-loop.sh` — a `while` loop over unblocked tickets running `claude -p "/foundry:implement <ticket>" --allowedTools ...` with fresh context per ticket and state on the board. Warn the user of the cost implications before starting, and set a per-sprint budget.
