---
name: llm-eval
description: Discipline for changing prompts, models, tools, or LLM
  orchestration. Use whenever an AI/LLM behavior change is made, before shipping.
---

# LLM Change & Eval Protocol

LLM changes are silent-regression-prone. Never ship a prompt/model/tool change
"by vibes" — run it against the eval set.

Before changing:
1. Identify the eval set that covers the behavior (dataset + scoring). If none
   exists for this behavior, add a few cases first.
2. Record the baseline: run current version, capture scores.

Making the change:
3. State the hypothesis (what should improve, what must not regress).
4. Make the minimal prompt/model/tool change.

Verifying:
5. Re-run the eval set. Compare against baseline case-by-case, not just aggregate.
6. Explicitly check for regressions on cases that previously passed.
7. Report: metric deltas, any newly-failing cases, and cost/latency impact
   (Opus vs Sonnet vs Haiku matters for the run).

Ship only if the change is a net improvement with no unexplained regression.
Save notable prompt decisions as an ADR.
