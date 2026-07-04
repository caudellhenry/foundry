---
name: grill
description: Interview the user one question at a time until every branch of the decision tree for a piece of work is resolved. Use at the start of any feature, fix, or refactor, before any plan or code.
disable-model-invocation: true
---

# /grill — resolve the decision tree

Misalignment is failure mode number one: the agent builds the wrong thing convincingly. Your job is to close the communication gap **before** anything is designed or built.

## Method

1. Read `intent.md` if present, plus `CONTEXT.md` and any PRD/tickets that already exist.
2. Ask **one question at a time**. Each question must build on the previous answer. Never ask two things in one message. Prefer concrete either/or framings over open questions.
3. Cover, in roughly this order: the user-visible outcome · who it is for · what already exists that this touches · edge cases and failure behaviour · what is explicitly out of scope · how we will know it works (candidate acceptance checks) · risks the user already suspects.
4. Stop when a new question would not change what gets built. Do not pad.

## Output

Write/update `intent.md`:

```markdown
# Intent: <one-line title>
date: <YYYY-MM-DD>

## Decision log
- <decision>: <choice> (<why>)

## Out of scope
- ...

## Parked questions
- <question> — parked because <reason>

## Candidate acceptance checks
- <observable pass/fail statement or command>

## Risks
- ...
```

If new domain terms surfaced, add them to `CONTEXT.md` (create it if needed) — a shared, ubiquitous language keeps every later session concise and consistently named.
