# ============================================================================
#  plugins-install.ps1  ·  reproducible plugin bootstrap (Windows)
#  Installs every plugin this setup expects, via the `claude` CLI. Re-runnable.
#
#  Requires: the `claude` CLI on PATH (Claude Code installed + signed in).
#  LSP plugins are connectors only — install the language-server binary too
#  (see the notes at the bottom / INSTALL-GUIDE.md Step 2).
#
#  Usage:  powershell -ExecutionPolicy Bypass -File .\plugins-install.ps1
# ============================================================================
$ErrorActionPreference = 'Continue'

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Error "'claude' CLI not found on PATH. Install Claude Code and sign in first."
  exit 1
}

Write-Host "== Adding community marketplaces =="
claude plugin marketplace add obra/superpowers-marketplace
claude plugin marketplace add thedotmack/claude-mem   # Claude Mem (required)

# Official marketplace (claude-plugins-official) is pre-registered.
$Official = @(
  'pyright-lsp',        # Python LSP    (binary: npm i -g pyright)
  'typescript-lsp',     # TS/JS LSP     (binary: npm i -g typescript typescript-language-server)
  'jdtls-lsp',          # Java LSP      (binary: install jdtls; needs JDK 17+)
  'clangd-lsp',         # C/C++ LSP     (binary: clangd via LLVM; needs compile_commands.json)
  'code-review',        # /code-review diff review
  'security-guidance',  # security review patterns
  'commit-commands',    # conventional-commit workflow
  'frontend-design',    # distinctive UI output
  'skill-creator'       # author your own skills
)

Write-Host "== Installing official plugins =="
foreach ($p in $Official) {
  Write-Host "  -> $p@claude-plugins-official"
  claude plugin install "$p@claude-plugins-official"
}

Write-Host "== Installing community plugins (required) =="
claude plugin install superpowers@superpowers-marketplace
claude plugin install claude-mem@thedotmack

Write-Host ""
Write-Host "Installed. Verify with:  claude plugin list"
Write-Host ""
Write-Host "LSP binaries (install only for languages you use):"
Write-Host "  Python:  npm i -g pyright"
Write-Host "  TS/JS:   npm i -g typescript typescript-language-server"
Write-Host "  Java:    install jdtls (JDK 17+ on PATH)"
Write-Host "  C/C++:   install clangd via LLVM (needs compile_commands.json)"
Write-Host "Then restart Claude Code (or run /reload-plugins) and test 'go to definition of X'."
