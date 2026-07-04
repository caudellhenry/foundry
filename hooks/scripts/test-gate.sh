#!/usr/bin/env bash
# Stop hook. Runs the active ticket's acceptance check from .foundry/state.json.
# Exit 2 blocks the turn from ending (Claude Code overrides after 8 consecutive blocks).
STATE=".foundry/state.json"
[ -f "$STATE" ] || exit 0
ACTIVE=$(python3 -c 'import json;d=json.load(open(".foundry/state.json"));print(d.get("gate_active") and d.get("check_command") or "")' 2>/dev/null)
[ -z "$ACTIVE" ] && exit 0
if bash -c "$ACTIVE" >/tmp/foundry-check.log 2>&1; then
  exit 0
else
  echo "foundry test-gate: acceptance check failed: $ACTIVE" >&2
  tail -n 20 /tmp/foundry-check.log >&2
  echo "Fix the failure or, if genuinely blocked, set gate_active=false in .foundry/state.json and explain why." >&2
  exit 2
fi
