#!/usr/bin/env bash
# ============================================================================
#  plugins-install.sh  ·  reproducible plugin bootstrap (macOS / Linux)
#  Installs every plugin this setup expects, via the `claude` CLI. Re-runnable.
#
#  Requires: the `claude` CLI on PATH (Claude Code installed + signed in).
#  LSP plugins are just connectors — install the language-server BINARY too
#  (see notes at the bottom / INSTALL-GUIDE.md Step 2) or they stay dormant.
# ============================================================================
set -uo pipefail

if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: 'claude' CLI not found on PATH. Install Claude Code and sign in first." >&2
  exit 1
fi

echo "== Adding community marketplaces =="
claude plugin marketplace add obra/superpowers-marketplace || true
claude plugin marketplace add thedotmack/claude-mem || true   # Claude Mem (required)

# Official marketplace (claude-plugins-official) is pre-registered.
OFFICIAL=(
  pyright-lsp          # Python LSP    (binary: npm i -g pyright)
  typescript-lsp       # TS/JS LSP     (binary: npm i -g typescript typescript-language-server)
  jdtls-lsp            # Java LSP      (binary: brew install jdtls; needs JDK 17+)
  clangd-lsp           # C/C++ LSP     (binary: clangd via LLVM; needs compile_commands.json)
  code-review          # /code-review diff review
  security-guidance    # security review patterns
  commit-commands      # conventional-commit workflow
  frontend-design      # distinctive UI output
  skill-creator        # author your own skills
)

echo "== Installing official plugins =="
for p in "${OFFICIAL[@]}"; do
  echo "  -> $p@claude-plugins-official"
  claude plugin install "${p}@claude-plugins-official" || echo "     (skipped/failed: $p)"
done

echo "== Installing community plugins (required) =="
claude plugin install superpowers@superpowers-marketplace || echo "  (skipped/failed: superpowers)"
claude plugin install claude-mem@thedotmack || echo "  (skipped/failed: claude-mem)"

echo ""
echo "Installed. Verify with:  claude plugin list"
echo ""
echo "LSP binaries (install only for languages you use):"
echo "  Python:  npm i -g pyright"
echo "  TS/JS:   npm i -g typescript typescript-language-server"
echo "  Java:    brew install jdtls           (JDK 17+ on PATH)"
echo "  C/C++:   install clangd via LLVM        (needs compile_commands.json)"
echo "Then restart Claude Code (or run /reload-plugins) and test with"
echo "'go to definition of X' — instant file:line + 'LSP' in output = working."
