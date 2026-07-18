#!/usr/bin/env python3
"""Stop hook — desktop notification when Claude finishes a turn.

WHY
  You (and your friends) may run PARALLEL Claude sessions in different repos /
  git worktrees. This pings you when one finishes and includes the directory
  name so you know WHICH session pinged.

CROSS-PLATFORM NOTIFICATION
  macOS   -> osascript (native notification)
  Linux   -> notify-send (desktop) — common on Ubuntu with a GUI
  Windows -> PowerShell toast via BurntToast if present, else a console beep
  Headless server -> falls back to printing a line to stderr (shows in logs)

  Every branch is best-effort and non-blocking: if nothing works we still exit 0.
"""
import os
import shutil
import subprocess
import sys


def notify(title: str, msg: str) -> bool:
    plat = sys.platform

    # ---- macOS ----
    if plat == "darwin" and shutil.which("osascript"):
        script = f'display notification "{msg}" with title "{title}"'
        subprocess.run(["osascript", "-e", script], check=False,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True

    # ---- Windows (native) ----
    if plat.startswith("win"):
        ps = shutil.which("powershell") or shutil.which("pwsh")
        if ps:
            # Try a real toast (needs the BurntToast module); fall back to a beep.
            cmd = (
                "if (Get-Module -ListAvailable -Name BurntToast) { "
                f"Import-Module BurntToast; New-BurntToastNotification -Text '{title}','{msg}' "
                "} else { [console]::beep(880,200) }"
            )
            subprocess.run([ps, "-NoProfile", "-Command", cmd], check=False,
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return True

    # ---- Linux desktop ----
    if shutil.which("notify-send"):
        subprocess.run(["notify-send", title, msg], check=False,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True

    # ---- WSL bridging to Windows ----
    if shutil.which("powershell.exe"):
        subprocess.run(["powershell.exe", "-NoProfile", "-Command",
                        "[console]::beep(880,200)"], check=False,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True

    return False


def main() -> None:
    where = os.path.basename(os.getcwd()) or "workspace"
    title, msg = "Claude Code", f"Finished in [{where}]"
    if not notify(title, msg):
        # Headless / no notifier available — leave a trace, never fail.
        sys.stderr.write(f"{title}: {msg}\n")
    sys.exit(0)


if __name__ == "__main__":
    main()
