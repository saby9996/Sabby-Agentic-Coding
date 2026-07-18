---
name: debug-protocol
description: Structured debugging. Use when facing a bug, failing test, or
  behavior that diverges from expectation and the cause is not obvious.
---

# Debug Protocol

Resist shotgun fixes. Follow the loop:

1. **Reproduce** — get a reliable, minimal repro. If you can, write a failing
   test that captures it (this becomes the regression test).
2. **Isolate** — bisect. Narrow to the smallest code path that still fails.
3. **Hypothesize** — state ONE concrete hypothesis about the cause.
4. **Instrument** — add targeted logging/asserts to confirm or kill it. Don't
   guess-and-edit.
5. **Fix** — the minimal change that addresses the confirmed cause.
6. **Verify** — repro test now passes; full suite still green; no orphaned code.

If two hypotheses remain after step 4, say so and pick the cheaper one to test
first. Never claim a fix without a passing check.
