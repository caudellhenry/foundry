#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../skills"
POOL="$HOME/.agents/skills"
SKILLS=(ship grill research prototype prd board implement tdd diagnose review qa security-review evals handoff)

echo "=== exporting foundry skills into shared pool as foundry-<name> ==="
for s in "${SKILLS[@]}"; do
  dest="$POOL/foundry-$s"
  rm -rf "$dest"
  cp -R "$SRC/$s" "$dest"
  python3 - "$dest/SKILL.md" "$s" <<'PY'
import sys, re
path, old = sys.argv[1], sys.argv[2]
text = open(path).read()
new_text, n = re.subn(rf'(?m)^name:\s*{re.escape(old)}\s*$', f'name: foundry-{old}', text, count=1)
if n == 0:
    print(f"WARN: name: {old} not found in {path}", file=sys.stderr)
open(path, 'w').write(new_text)
PY
  echo "exported foundry-$s"
done

echo "=== symlinking into Hermes and OpenCode ==="
for s in "${SKILLS[@]}"; do
  name="foundry-$s"
  for target in "$HOME/.hermes/skills" "$HOME/.opencode/skills"; do
    if [ -d "$target" ]; then
      ln -sfn "../../.agents/skills/$name" "$target/$name"
    fi
  done
done
echo "=== done ==="
