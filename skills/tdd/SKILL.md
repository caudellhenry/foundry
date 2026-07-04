---
name: tdd
description: Red–green–refactor discipline for implementing any behaviour change or bug fix — write the failing test first, make it pass minimally, then refactor. Use whenever writing production code.
---

# tdd — red, green, refactor

Tests are the agent's own feedback signal: with a real suite the loop closes without a human. Without one, an agent may claim work is done that was never run.

## The loop (one behaviour at a time)

1. **Red.** Write ONE failing test for the next smallest behaviour. Run it; confirm it fails **for the right reason** (assertion, not import error). A test that passes immediately is testing nothing — delete or fix it.
2. **Green.** Write the minimum code to pass. Resist implementing ahead of the tests.
3. **Refactor.** With green as the safety net: improve names, extract deep modules behind small interfaces, remove duplication. Run the whole suite again.
4. Repeat until the ticket's acceptance check passes.

## Test quality rules

- Test observable behaviour through the module's public interface, never internals.
- One behaviour per test; name it after the behaviour ('rejects expired tokens'), not the method.
- Bug fixes start with a regression test that reproduces the bug.
- Do not bloat: if an existing test already covers the behaviour, extend it rather than duplicating.
- Never weaken or delete a failing test to get green without explicit human sign-off.
