---
name: plan-first
description: Use before implementing any feature, refactor, or change that
  touches architecture, data models, public APIs, dependencies, or multiple
  modules. Produces a short spec and pauses at architectural decisions only.
---

# Plan First

The autonomy contract: free rein on implementation, stop only at architectural
decision points. This skill defines the "before you code" pass.

1. Restate the task in one paragraph. List explicit assumptions.
2. Identify affected files/modules and anything deliberately out of scope.
3. Define success criteria (the tests/checks that will prove it works).
4. If the task involves an architectural decision (new service boundary, schema
   change, new dependency, public contract change, anything hard to reverse):
   present 2–3 options with trade-offs and STOP for my decision.
5. If it's purely implementation within an agreed design: state the plan in a
   few lines and proceed — do not wait for approval.

Keep the plan short. This is a checkpoint, not a document.
