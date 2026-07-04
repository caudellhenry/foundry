---
name: ship
description: Orchestrate a feature, fix, or app from idea to production through the foundry pipeline (Idea → Research → Prototype → PRD → Board → Execution → QA). Use when the user wants to start, resume, or check the status of a piece of work.
disable-model-invocation: true
---

# /ship — the pipeline orchestrator

You are the state machine for the foundry delivery pipeline. You never do phase work yourself; you route to the phase skills and keep `.foundry/state.json` true.

## On invocation

1. Read `.foundry/state.json`. If missing, create it:
   ```json
   { "phase": "idea", "sprint": "<YYYY-MM-DD>", "ticket": null, "prd_ref": null,
     "research_expiry": null, "iteration_chain": {"failure_id": null, "count": 0},
     "gate_active": false, "check_command": null,
     "gates": {"qa_quiz_passed": false, "security_ok": false, "evals_pass3": false} }
   ```
2. If the user supplied an idea in the invocation, record it verbatim in `intent.md` (create if missing) and start Phase 1.
3. Otherwise report: current phase, active ticket, gate status, and the single next command.

## Routing rules

- **Phase 1 (idea):** run the `grill` skill. When intent.md shows every decision resolved or parked → triage.
- **Triage (the one-sentence rule):** if the grilled intent describes a single-file, single-behaviour change, skip straight to `implement` with an inline acceptance check. Otherwise continue.
- **Phase 2 (research, conditional):** offer ONLY if intent.md names an external dependency that needs hard exploration (unfamiliar API, niche SDK). Skip when the dependency is stable and well known. Run the `research` skill.
- **Phase 3 (prototype, conditional):** offer ONLY if a taste or architecture question is unresolved (UI feel, structural choice, live external test). Run the `prototype` skill.
- **Phase 4 (prd, mandatory):** run the `prd` skill.
- **Phase 5 (board, mandatory):** run the `board` skill.
- **Phase 6 (execute):** run the `implement` skill per ticket; loop while unblocked tickets remain.
- **Phase 7 (qa):** run `review` then `qa`. QA findings become new tickets → back to phase 5. Loop 5→6→7 until the board is empty and gates pass.

## Invariants (enforce every run)

- Update `state.json` before ending your turn; print the next command for the user.
- Conditional phases must justify themselves in one line when offered.
- Never mark a phase done without its artefact on disk (intent.md, research.md, prototype commit, PRD, tickets).
- Never bypass the human gates: PRD approval, QA walkthrough, comprehension quiz.
