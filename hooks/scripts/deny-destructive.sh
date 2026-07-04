#!/usr/bin/env bash
# PreToolUse (Bash). Conservative deny-list; exit 2 blocks.
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)
[ -z "$CMD" ] && exit 0
if printf '%s' "$CMD" | grep -qE 'rm -rf +(/|~|\$HOME)([[:space:]]|$)'; then
  echo "foundry: refusing rm -rf on home or filesystem root." >&2; exit 2
fi
if printf '%s' "$CMD" | grep -qE '(curl|wget)[^|;&]*\|[[:space:]]*(ba)?sh'; then
  echo "foundry: curl-pipe-to-shell is blocked. Download, inspect, then run." >&2; exit 2
fi
if printf '%s' "$CMD" | grep -qE 'git reset --hard[^|;&]*origin/(main|master)'; then
  echo "foundry: hard reset to remote main is blocked (destroys local work)." >&2; exit 2
fi
exit 0
