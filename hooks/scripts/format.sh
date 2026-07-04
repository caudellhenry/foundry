#!/usr/bin/env bash
# PostToolUse (Edit|Write). Best-effort formatting of the touched file. Always exits 0.
INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null)
[ -z "$FILE" ] || [ ! -f "$FILE" ] && exit 0
DIR=$(cd "$(dirname "$FILE")" && pwd)
case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.md)
    if command -v npx >/dev/null 2>&1 && [ -f "$DIR/../package.json" -o -f "$DIR/package.json" ]; then
      npx --no-install prettier --write "$FILE" >/dev/null 2>&1 || true
    fi ;;
  *.py)
    command -v ruff >/dev/null 2>&1 && ruff format "$FILE" >/dev/null 2>&1 || true ;;
  *.go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$FILE" >/dev/null 2>&1 || true ;;
  *.rs)
    command -v rustfmt >/dev/null 2>&1 && rustfmt "$FILE" >/dev/null 2>&1 || true ;;
esac
exit 0
