#!/usr/bin/env python3
"""PostToolUse hook for Edit / Write / MultiEdit — auto-format the edited file.

WHAT IT DOES
  After Claude edits or writes a file, Claude Code pipes the tool-call JSON here.
  We read which file changed and run the right formatter for its extension:
    .py                      -> ruff format + ruff check --fix
    .ts/.tsx/.js/.jsx/... -> prettier (or `npx prettier` if not global)
  The formatter RUNNING automatically beats Claude REMEMBERING to run it.

NON-BLOCKING BY DESIGN
  If the formatter isn't installed, or anything fails, we just skip and exit 0.
  Missing tools must never break an edit. Install `ruff` / `prettier` to benefit;
  do nothing and formatting is simply skipped.

CROSS-PLATFORM
  Pure Python + shutil.which() for tool discovery — works on macOS, Linux, and
  native Windows without bash.
"""
import json
import shutil
import subprocess
import sys


def read_path() -> str:
    """Pull the edited file path out of the hook payload on stdin."""
    try:
        ti = json.load(sys.stdin).get("tool_input") or {}
    except Exception:
        return ""
    return ti.get("file_path") or ti.get("path") or ""


def run(cmd: list[str]) -> None:
    """Best-effort run; swallow all output and errors (formatting is optional)."""
    try:
        subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
    except Exception:
        pass


# Extension -> formatter builder. `path` is filled in at call time.
def format_file(path: str) -> None:
    lower = path.lower()
    if lower.endswith(".py"):
        if shutil.which("ruff"):
            run(["ruff", "format", path])
            run(["ruff", "check", "--fix", path])
    elif lower.endswith((".ts", ".tsx", ".js", ".jsx", ".json", ".css", ".scss", ".md")):
        if shutil.which("prettier"):
            run(["prettier", "--write", path])
        elif shutil.which("npx"):
            run(["npx", "--no-install", "prettier", "--write", path])


def main() -> None:
    import os

    path = read_path()
    if not path or not os.path.isfile(path):
        sys.exit(0)
    format_file(path)
    sys.exit(0)


if __name__ == "__main__":
    main()
