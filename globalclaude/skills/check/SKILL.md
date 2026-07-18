---
name: check
description: Fast static gate — typecheck + lint — run before the test/review
  bar. Use after edits, or when the user types /check, to catch trivial breakage
  cheaply before spending time on tests.
---

# Check (typecheck + lint gate)

A cheap gate that runs before the full verification bar. Order in the workflow:
**check → tests → code-review → manual**.

Run in sequence, report concisely, stop at the first hard failure:

TypeScript / React:
- `tsc --noEmit` (or `pnpm tsc --noEmit`)
- `eslint .` (or the repo's lint script)

Python:
- `ruff check .`
- `mypy .` if the project uses it

Report format: one line per tool (pass/fail + count). For failures, group by
file, show the specific errors (not full output), and propose the minimal fix.
Do NOT auto-fix beyond what `ruff check --fix` / `eslint --fix` safely handle —
surface type errors for a real decision. This is a gate, not a rewrite pass.
