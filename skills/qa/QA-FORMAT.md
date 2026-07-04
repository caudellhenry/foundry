# QA plan format

```markdown
# QA: <ticket/PRD title>
date: YYYY-MM-DD
pr: <url>

## Walkthrough
1. <exact command / click> → expect: <observation>   [AC1]

## Edge cases to poke
- <input/state> → expect: <behaviour>

## Literate diff (read the code in this order)
1. <file> — <what changed and why>
Suspicious spots: <where a bug would hide>

## Comprehension quiz (pass before merge)
1. <question>

## Findings
- [ ] <finding> → ticket #n
```
