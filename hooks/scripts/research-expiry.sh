#!/usr/bin/env bash
# SessionStart hook. Warns when research.md is past its expires: date.
F="research.md"
[ -f "$F" ] || exit 0
EXP=$(grep -m1 -E '^expires:' "$F" | sed 's/expires:[[:space:]]*//')
[ -z "$EXP" ] && { echo "foundry: research.md has no 'expires:' line — treat as stale (research rots)."; exit 0; }
TODAY=$(date +%Y-%m-%d)
if [ "$TODAY" \> "$EXP" ]; then
  echo "foundry: research.md EXPIRED on $EXP. Do not rely on it; re-run /foundry:research or delete it."
fi
exit 0
