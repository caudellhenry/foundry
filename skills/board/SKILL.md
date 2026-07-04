---
name: board
description: Break an approved PRD into vertical-slice tickets with explicit blocking relationships on GitHub Issues or Linear, so agents can execute them independently. Use after PRD approval.
disable-model-invocation: true
---

# /board — vertical slices with blocking

The board is the source of truth for what an agent may pick up next. Intelligence lives in the tickets, not in any session's memory.

## Slicing rules

- **Vertical slices only**: each ticket cuts end-to-end through one path (UI → API → data → test) so a fresh-context agent holds the whole story. A ticket touching only one layer must justify itself in the ticket body or be merged into a slice.
- Size for one focused agent session. Too big → split by user-visible sub-behaviour, never by layer.
- Every ticket carries: a self-contained description (no reference to 'the conversation'), **its own acceptance check** (command or manual observation, drawn from the PRD's ACs), blocking links, and a size hint (S/M/L).

## Method

1. Read `PRD.md`. Map every acceptance criterion to at least one ticket; no ticket without an AC, no AC without a ticket.
2. Derive the blocking graph (data model before endpoints before UI where genuinely required — otherwise leave unblocked for parallelism). Prefer Linear when true blocking semantics matter; GitHub Issues otherwise (encode blockers as `Blocked by: #n` lines).
3. Create the tickets via MCP in one batch, linked to the PRD parent issue.
4. Show the user the board as a table (ticket · slice · check · blocked-by) for a sanity pass.
5. Update `.foundry/state.json`: phase `execute`.
