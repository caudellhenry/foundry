#!/usr/bin/env bash
# PreToolUse (Bash). Exit 2 blocks the tool call; stderr is shown to the model.
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)
[ -z "$CMD" ] && exit 0
if printf '%s' "$CMD" | grep -qE 'git push[^|;&]*(--force|-f)\b'; then
  echo "foundry: force-push is blocked. Open a PR instead." >&2; exit 2
fi
if printf '%s' "$CMD" | grep -qE 'git push[^|;&]*\b(origin[[:space:]]+)?(main|master)\b'; then
  echo "foundry: direct push to main/master is blocked. Work on a branch and open a PR." >&2; exit 2
fi
if printf '%s' "$CMD" | grep -qE '^\s*git checkout (main|master)\s*&&\s*git (commit|merge)'; then
  echo "foundry: committing/merging directly on main/master is blocked." >&2; exit 2
fi
exit 0
