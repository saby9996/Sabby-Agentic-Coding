#!/usr/bin/env bash
# ============================================================================
#  install.sh  ·  macOS / Linux / servers
#  Installs the global layer (globalclaude/) into ~/.claude and makes the
#  Python hooks executable. Safe to re-run (idempotent). Backs up an existing
#  ~/.claude first so you never lose a prior setup.
#
#  Usage:
#     ./install.sh              # merge globalclaude/ into ~/.claude
#     CLAUDE_HOME=/path ./install.sh   # install somewhere other than ~/.claude
# ============================================================================
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/globalclaude"
DEST="${CLAUDE_HOME:-$HOME/.claude}"

if [ ! -d "$SRC" ]; then
  echo "ERROR: $SRC not found. Run this from inside the package folder." >&2
  exit 1
fi

# --- Check Python 3 (hooks + statusline need it) ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "WARNING: python3 not found on PATH. The hooks and status line will not" >&2
  echo "         run until Python 3 is installed. Continuing with file copy." >&2
fi

# --- Back up an existing install ---
if [ -d "$DEST" ]; then
  STAMP="$(date +%Y%m%d-%H%M%S)"
  BACKUP="${DEST}.backup-${STAMP}"
  echo "Existing $DEST found — backing up to $BACKUP"
  cp -R "$DEST" "$BACKUP"
fi

mkdir -p "$DEST"

# --- Copy the global layer in (merge; your settings.local.json is untouched) ---
# We intentionally do NOT overwrite settings.local.json (machine-local).
cp -R "$SRC"/. "$DEST"/

# --- Make hooks executable (exec bit is lost in zips/downloads) ---
chmod +x "$DEST"/hooks/*.py 2>/dev/null || true

echo ""
echo "Installed global layer -> $DEST"
echo "Files:"
ls -1 "$DEST"
echo ""
echo "Smoke-test the guardrail hook:"
if command -v python3 >/dev/null 2>&1; then
  printf '%s' '{"tool_input":{"command":"git push --force origin main"}}' \
    | python3 "$DEST/hooks/block_dangerous.py"; rc=$?
  echo "   exit=$rc  (expected: a GUARDRAIL BLOCK line and exit=2)"
fi
echo ""
echo "Next: install the plugins ->  ./plugins-install.sh   (or run the /plugin"
echo "commands from INSTALL-GUIDE.md Step 2 inside Claude Code)."
