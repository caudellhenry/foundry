# research.md format

```markdown
# Research: <topic(s)>
date: YYYY-MM-DD
expires: YYYY-MM-DD   # sprint end; SessionStart hook warns past this date
sprint: <sprint id or date>

## Questions this answers
- ...

## Findings
### <question or area>
- <finding> — source: <url>
- Verified against: <second url>   # for anything surprising

## Could not verify
- <claim> — why it matters, what was tried

## Do NOT rely on this file for
- <adjacent topics deliberately out of scope>
```

Rules: primary sources only · one file per sprint · delete or regenerate after expiry · never let an agent cite this file past its expiry.
