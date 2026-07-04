---
name: evals
description: Scaffold and run the project's agent eval suite — tasks drawn from real observed failures, graded by executable checks, with pass^k reporting and a CI gate. Use after QA finds failures, and on any change to prompts, skills, or tools.
disable-model-invocation: true
---

# /evals — make decay loud

Prompts, skills, and tool descriptions decay silently across model and harness versions. The eval suite is what makes that decay visible before users see it.

## Scaffold (first run)

1. Create `evals/` with one folder per task: `task.md` (setup, instruction, pass/fail command), fixtures, and `expected/` where relevant.
2. Seed from **real observed failures** (QA findings, review blockers, bug tickets) — 20–50 simple tasks is a great start; do not wait for hundreds, and do not invent synthetic ones.
3. Quality bar per task: two maintainers would independently reach the same pass/fail verdict. If a task scores 0% across many trials, suspect the task before the agent.
4. Grade with executable checks only. LLM-as-judge is not robust — style feedback at most, never correctness.

## Run

- `evals/run.sh [k]` executes each task k times headlessly (`claude -p`) and reports **pass@k and pass^k** per task. Release-gating tasks use pass^3 — consistency, not luck (75% per-trial ≈ only 42% for three straight passes).
- Wire into CI: the suite runs on every change to `skills/`, `hooks/`, prompts, or model/harness version pins. Failures block release. Record `gates.evals_pass3`.
- Every new real-world failure becomes a task. The suite only grows.
