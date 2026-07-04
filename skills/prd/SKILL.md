---
name: prd
description: Synthesise the destination document (PRD) for a piece of work — what the user sees and how it behaves, never the implementation — from the grilled intent, research, and winning prototype. Use after grilling (and any research/prototype) and before ticketing.
disable-model-invocation: true
---

# /prd — the destination document

The PRD constrains **what and why**; the agent later decides **how**. If a sentence describes implementation, cut it or move it to a design note.

## Method

1. Work in **plan mode** semantics: read `intent.md`, `research.md` (check expiry), the `prototype:` commit, and `CONTEXT.md`. Make no code changes.
2. Draft the PRD per [PRD-FORMAT.md](PRD-FORMAT.md). Every acceptance criterion must be a pass/fail statement — an executable command where possible, a human-checkable observation otherwise.
3. Grill the user on any gap the draft exposes (one question at a time — invoke the `grilling` discipline from the grill skill).
4. Present the draft. **The human approves the PRD** — this gate is never skipped.
5. On approval: publish to the tracker (GitHub/Linear via MCP) as the parent issue, write `PRD.md` to the repo, set `prd_ref` in `.foundry/state.json`, advance phase to `board`.

## Quality bar

- Observable behaviour only; zero implementation detail.
- An explicit **out of scope** list (the cheapest scope-creep defence).
- Acceptance criteria a fresh-context agent could verify without this conversation.
