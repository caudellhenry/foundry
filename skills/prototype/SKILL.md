---
name: prototype
description: Build throwaway prototypes to answer a named design question before the PRD locks anything down — UI look-and-feel variants, an architecture spike, or a live test against an external service. Use when taste or a structural choice cannot be decided on paper.
---

# prototype — concrete before abstract

By PRD time it is too abstract to decide taste; you need concrete feedback first. Prototypes are disposable by definition — only the winner survives, and only as reference.

## Method

1. State the **design question** this prototype answers, in one line. If you cannot, stop — no prototype is needed.
2. Create an isolated workspace: a git worktree (ask to use worktrees, or `--worktree`) or a clearly disposable route/folder named `prototype/`.
3. Build **two or three radically different** variants, not variations on one idea:
   - UI question → variants toggleable from one route.
   - State/logic question → a runnable terminal harness.
   - External-service question → the smallest real call that proves the integration.
4. Present the variants to the user with a one-line trade-off each. **The human picks.** Never pick for them.
5. Commit the winner with a `prototype:` prefix so the execution agent can read it later; delete the losers and remove the scratch worktree.
6. Record anything learned about externals in `research.md`; record the decision in `intent.md`'s decision log.

Never ship prototype code as production code — Phase 6 reimplements it properly under TDD.
