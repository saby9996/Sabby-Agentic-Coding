---
name: implement
description: OPTIONAL structured implementation pipeline that routes work to
  specialist agents with a self-eval loop. Use when you want clean layer
  separation on a larger feature. Invoke with /implement. For small changes,
  skip this — default is free-rein direct implementation.
---

# Implement (routed pipeline)

This is opt-in. Your default autonomy is free-rein direct implementation; reach
for this pipeline only on features big enough to benefit from layer separation.

Given an agreed plan (from plan-first), route by task type:
1. **Structural / new boundaries** → `architect` first (design the layers/data flow).
2. **Business logic, hooks, state, transforms** → `logic-expert`.
3. **Pure UI / presentation components** → `ui-publisher`.
4. Keep logic and presentation in separate changes so the diff stays legible.

After the specialists produce code:
5. Run `evaluator` — self-check against the success criteria, fix trivial gaps,
   loop up to 3×.
6. Then hand to the standard verification bar: `check` → test-runner →
   code-reviewer → my manual review. Do not commit until I approve.

Guardrails: architectural decisions still stop for me (per plan-first). Don't let
the pipeline fragment a small change into ceremony — if the task is a few files,
just do it directly instead of invoking this.
