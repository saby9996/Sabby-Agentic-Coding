#!/usr/bin/env python3
"""PreToolUse hook for Bash — the deterministic guardrail.

WHAT IT DOES
  Claude Code pipes the tool-call JSON to this script on stdin BEFORE a Bash
  command runs. If the command matches a dangerous pattern we print a reason to
  stderr and exit 2 — that BLOCKS the command and the reason is fed back to
  Claude. Any other exit code (0) lets the command through.

WHY PYTHON (not bash)
  This one file runs identically on macOS, Linux, and native Windows. No bash,
  no jq — only a Python 3 interpreter, which every dev machine already has.

FAIL-OPEN BY DESIGN
  If anything unexpected happens (bad JSON, no command field) we exit 0 = allow.
  The settings.json permission deny-list is the primary gate; this hook is a
  second, pattern-based layer. It must never break a normal session.

  NOTE: a guardrail is not a security boundary. It stops honest mistakes and
  obvious footguns, not a determined adversary. Keep the deny-list in
  settings.json as the real gate.
"""
import json
import re
import sys


def read_command() -> str:
    """Pull .tool_input.command out of the hook payload on stdin."""
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return ""  # unparseable -> allow (fail open)
    return (payload.get("tool_input") or {}).get("command", "") or ""


# Each entry: (compiled regex, human reason). Matching is case-insensitive.
# Add your own patterns here — keep them specific so normal work isn't blocked.
RULES = [
    (r"rm\s+-rf\s+/(\s|$)",                 "rm -rf on filesystem root"),
    (r"rm\s+-rf\s+/\*",                     "rm -rf /*"),
    (r"rm\s+-rf\s+~",                        "rm -rf home directory"),
    (r":\(\)\s*\{.*\|.*&\s*\}\s*;",          "fork bomb"),
    (r"git\s+push[^|;&]*(--force|-f)(\s|$)", "force push"),
    (r"(DROP|TRUNCATE)\s+(TABLE|DATABASE|SCHEMA)", "destructive SQL (DROP/TRUNCATE)"),
    (r">\s*\.env",                           "overwrite of .env"),
    (r"chmod\s+-R\s+777",                    "recursive chmod 777"),
    (r"curl[^|;&]*\|\s*(bash|sh)(\s|$)",     "curl | bash (remote code execution)"),
    (r"wget[^|;&]*\|\s*(bash|sh)(\s|$)",     "wget | sh (remote code execution)"),
    (r"(^|[\s&;|])sudo\s",                   "sudo (privilege escalation)"),
]


def block(reason: str, cmd: str) -> None:
    sys.stderr.write(f"GUARDRAIL BLOCK: {reason}. Refusing: {cmd}\n")
    sys.exit(2)


def main() -> None:
    cmd = read_command()
    if not cmd:
        sys.exit(0)

    for pattern, reason in RULES:
        if re.search(pattern, cmd, re.IGNORECASE):
            block(f"matched forbidden pattern /{pattern}/ ({reason})", cmd)

    # Direct push to main/master — word-bounded so 'maintenance'/'remaining' pass.
    if re.search(r"git\s+push", cmd, re.IGNORECASE) and re.search(
        r"(^|[\s:/])(main|master)([\s\"';]|$)", cmd, re.IGNORECASE
    ):
        block("direct push targeting main/master", cmd)

    # Unbounded DELETE: DELETE FROM ... with no WHERE clause.
    if re.search(r"DELETE\s+FROM\s+", cmd, re.IGNORECASE) and not re.search(
        r"\sWHERE\s", cmd, re.IGNORECASE
    ):
        block("DELETE FROM without a WHERE clause", cmd)

    sys.exit(0)


if __name__ == "__main__":
    main()
