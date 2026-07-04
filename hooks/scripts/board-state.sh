#!/usr/bin/env bash
# SessionStart hook. Stdout is added to context.
STATE=".foundry/state.json"
[ -f "$STATE" ] || exit 0
python3 - <<'PY' 2>/dev/null
import json
d = json.load(open(".foundry/state.json"))
print("foundry pipeline state: phase=%s sprint=%s ticket=%s prd=%s" % (
    d.get("phase","?"), d.get("sprint","?"), d.get("ticket","-"), d.get("prd_ref","-")))
gates = d.get("gates", {})
if gates: print("foundry gates:", ", ".join(f"{k}={v}" for k,v in gates.items()))
ic = d.get("iteration_chain", {})
if ic.get("count",0) >= 2:
    print("foundry warning: iteration chain at %s on failure '%s' — human review required at 3." % (ic.get("count"), ic.get("failure_id")))
PY
exit 0
