---
name: loop-runner
description: Run an autonomous goal-driven loop until success criteria are met.
  Use for tasks with clear, checkable success criteria (make tests pass,
  eliminate type errors, get a feature working end-to-end). Invoke with /loop.
---

# Loop Runner

Karpathy's key insight: LLMs are exceptionally good at looping until they hit a
concrete goal. This skill turns a task into a verifiable loop. It pairs with the
verification bar (tests → code-reviewer → manual).

## Setup (do this once per loop)
1. **Define the success criterion as a command that exits 0/non-0.** Examples:
   - `uv run pytest tests/feature_x -q`
   - `pnpm tsc --noEmit`
   - `npx playwright test e2e/checkout.spec.ts`
   Write it down explicitly. If you can't express success as a check, STOP and
   ask me to clarify the goal — a loop without a hard criterion is dangerous.
2. Write the criterion and a plan to a scratch file (`.claude/loop/PLAN.md` in
   the repo) so progress survives context compaction.

## The loop
Repeat until the criterion command exits 0 (or the guard trips):
1. Run the criterion command. If it passes → go to Exit.
2. Read the failure output. Form ONE hypothesis (see debug-protocol).
3. Make the smallest change consistent with karpathy-guidelines (surgical, simple).
4. Re-run. Log one line to PLAN.md: what you tried, result.

## Guards (prevent runaway loops)
- Max 8 iterations without visible progress → STOP and summarize what's stuck.
- If a change would touch architecture, a data model, or a public contract →
  STOP and surface it (that's an architectural decision point, not loop work).
- Never weaken/delete a test to make the criterion pass. If the test is wrong,
  say so and stop.
- If two consecutive iterations make the same failure worse → revert and stop.

## Exit
When the criterion passes:
1. Run the test-runner subagent (full suite, not just the target).
2. Run the code-reviewer subagent on the diff.
3. Report: criterion met, review summary, and hand off for my manual review.
   Do NOT commit until I approve (git push/PR always needs approval anyway).
