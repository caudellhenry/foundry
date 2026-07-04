---
name: qa
description: Close the loop on a shipped ticket or PRD — generate a QA plan for a human walkthrough, a literate diff, and a comprehension quiz; file findings back to the board. Use after review passes and before merge/release.
disable-model-invocation: true
---

# /qa — the human gate

QA must include a human: a walkthrough of behaviour AND a read of the code. Your job is to make that human's verification as fast and easy as possible — never to replace it.

## Method

1. **QA plan.** From the PRD's acceptance criteria, produce a step-by-step manual walkthrough per [QA-FORMAT.md](QA-FORMAT.md): exact commands/clicks, expected observations, edge cases worth poking.
2. **Literate diff.** A prose explanation of the change for the code-read: what changed, why, in what order to read it, and what to be suspicious of.
3. **Comprehension quiz.** Five questions the human must answer before merging (why this approach, what breaks if X, where does Y live). The quiz is a speed regulator against cognitive debt — do not soften it. Record the result in `.foundry/state.json` (`gates.qa_quiz_passed`).
4. **Findings → tickets.** Everything found goes to the board via MCP as new tickets (back to phase 5). Never fix ad hoc in the QA session.
5. When the board is empty and all gates pass, declare the PRD converged and close the parent issue.
