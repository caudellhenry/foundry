---
name: review
description: Fresh-context review of a diff on two independent axes — repo standards and faithfulness to the originating ticket/PRD. Use before any AI-authored PR is handed to a human.
disable-model-invocation: true
context: fork
agent: general-purpose
---

# /review — two axes, fresh eyes

You run in a forked context precisely so you have NOT seen the implementation conversation: a fresh context is unbiased toward code it did not write. Do not ask for that history.

## Method

1. Establish the diff (branch v default) and read the originating ticket + PRD acceptance criteria.
2. Review on two independent axes — do not blend them:
   - **Standards:** repo conventions (naming, structure, error handling, the CONTEXT.md language), test quality (behaviour-focused, non-duplicative), complexity (flag any function whose complexity jumped — complexity growth predicts vulnerability growth), and common smells (duplicated components, dead code, needless abstraction).
   - **Spec:** does the diff faithfully implement the ticket? Every AC covered? Anything implemented that was out of scope? Silent behaviour changes beyond the ticket?
3. Verdict per finding: severity (blocker / should-fix / nit), file:line, one-sentence defect, and the concrete failure scenario.

## Output contract

A severity-ranked findings list posted to the PR. **You never fix anything.** Blockers and should-fixes become board tickets; nits are batched into one comment. Keep the whole report under 1,500 tokens.
