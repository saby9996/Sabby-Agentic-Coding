# ============================================================================
#  install.ps1  ·  Windows (PowerShell 5+ / PowerShell 7)
#  Installs the global layer (globalclaude\) into %USERPROFILE%\.claude.
#  Windows often exposes Python as `python` or `py` rather than `python3`, so
#  after copying we patch settings.json to use whichever interpreter exists.
#  Safe to re-run. Backs up an existing .claude first.
#
#  Usage (from inside the package folder):
#     powershell -ExecutionPolicy Bypass -File .\install.ps1
# ============================================================================
$ErrorActionPreference = 'Stop'

$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Src  = Join-Path $Here 'globalclaude'
$Dest = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $env:USERPROFILE '.claude' }

if (-not (Test-Path $Src)) {
  Write-Error "globalclaude\ not found next to this script. Run it from inside the package folder."
  exit 1
}

# --- Find a Python 3 interpreter: prefer `python`, then the `py -3` launcher ---
$PyCmd = $null
foreach ($c in @('python','python3','py')) {
  if (Get-Command $c -ErrorAction SilentlyContinue) {
    if ($c -eq 'py') { $PyCmd = 'py -3' } else { $PyCmd = $c }
    break
  }
}
if (-not $PyCmd) {
  Write-Warning "No Python 3 found (python/python3/py). Install Python 3 from python.org or the Microsoft Store, then re-run. Continuing with file copy."
  $PyCmd = 'python'  # write a sensible default into settings.json anyway
}

# --- Back up an existing install ---
if (Test-Path $Dest) {
  $Stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'
  $Backup = "$Dest.backup-$Stamp"
  Write-Host "Existing $Dest found - backing up to $Backup"
  Copy-Item $Dest $Backup -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

# --- Copy the global layer in (merge) ---
Copy-Item (Join-Path $Src '*') $Dest -Recurse -Force

# --- Patch settings.json so hook commands use the detected interpreter ---
# The shipped file uses `python3`; swap it for whatever this machine has.
$SettingsPath = Join-Path $Dest 'settings.json'
if ((Test-Path $SettingsPath) -and ($PyCmd -ne 'python3')) {
  $json = Get-Content $SettingsPath -Raw
  $json = $json -replace 'python3 ', "$PyCmd "
  Set-Content -Path $SettingsPath -Value $json -Encoding UTF8
  Write-Host "Patched settings.json hook interpreter -> '$PyCmd'"
}

Write-Host ""
Write-Host "Installed global layer -> $Dest"
Get-ChildItem $Dest | Select-Object -ExpandProperty Name

# --- Smoke-test the guardrail hook ---
Write-Host ""
Write-Host "Smoke-test the guardrail hook (expect a GUARDRAIL BLOCK line):"
$block = Join-Path $Dest 'hooks\block_dangerous.py'
'{"tool_input":{"command":"git push --force origin main"}}' | & cmd /c "$PyCmd `"$block`""
Write-Host "   exit=$LASTEXITCODE  (expected: 2)"

Write-Host ""
Write-Host "Next: install the plugins ->  .\plugins-install.ps1   (or run the /plugin"
Write-Host "commands from INSTALL-GUIDE.md Step 2 inside Claude Code)."
