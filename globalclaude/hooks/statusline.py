#!/usr/bin/env python3
"""statusLine command — renders the line at the bottom of the Claude Code UI.

OUTPUT:  <dir>  ⎇ <git-branch>  ⟨<model>⟩      e.g.   my-repo  ⎇ main  ⟨Opus⟩

HOW IT WORKS
  Claude Code pipes session JSON on stdin (it contains the model display name).
  We print ONE line to stdout — that becomes the status line. Keep it fast and
  side-effect free; it runs often.

CROSS-PLATFORM
  Pure Python + a `git` subprocess. Works on macOS, Linux, and native Windows.
  If git isn't a repo (or isn't installed) the branch shows as '-'.
"""
import json
import subprocess
import sys
import os


def model_name() -> str:
    try:
        data = json.load(sys.stdin)
    except Exception:
        return "?"
    return (data.get("model") or {}).get("display_name", "?") or "?"


def git_branch() -> str:
    try:
        out = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, check=False,
        )
        branch = out.stdout.strip()
        return branch or "-"
    except Exception:
        return "-"


def main() -> None:
    model = model_name()
    where = os.path.basename(os.getcwd()) or "~"
    branch = git_branch()
    # ⎇ (branch) and ⟨ ⟩ are plain Unicode; render fine in modern terminals.
    sys.stdout.write(f"{where}  ⎇ {branch}  ⟨{model}⟩")


if __name__ == "__main__":
    main()
