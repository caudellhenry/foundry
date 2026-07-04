# PRD.md format

```markdown
# PRD: <title>
date: YYYY-MM-DD
intent: intent.md
research: research.md (expires YYYY-MM-DD) | none
prototype: <commit sha> | none
tracker: <issue url>

## Summary
One paragraph: what exists when this ships that does not exist now.

## User-visible behaviour
### <flow or surface>
- When <situation>, the user sees/gets <behaviour>.

## Edge cases and failure behaviour
- When <bad input / outage / race>, the system <does X>.

## Out of scope
- ...

## Acceptance criteria
- [ ] AC1: <pass/fail statement> — check: `<command>` | manual: <observation>

## Open questions (deferred, non-blocking)
- ...
```

Rules: behaviour, never implementation · every AC pass/fail · out-of-scope list mandatory.
