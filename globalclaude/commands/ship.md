---
description: Run the full verification bar on the current diff.
---
Run the verification bar in order:
1. check skill (typecheck + lint gate) — stop and report if it fails hard.
2. test-runner subagent (full suite).
3. code-reviewer subagent on the current diff.
4. security-auditor subagent IF the diff touches auth, data handling, or external
   integrations.
Summarize results and tell me it's ready for manual review. Do not commit or push.
$ARGUMENTS
