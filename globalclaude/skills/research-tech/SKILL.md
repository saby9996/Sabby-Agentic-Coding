---
name: research-tech
description: Structured technology evaluation and comparison. Use when choosing
  a library, framework, database, or vendor, or when researching whether an
  approach is viable.
---

# Technology Research

Produce a decision-grade evaluation, not a link dump.

1. **Criteria** — list what actually matters for this decision (maturity,
   performance envelope, license, community/maintenance, ops burden, lock-in,
   fit with our stack). Weight them.
2. **Candidates** — 2–4 real options. Use `deep-researcher` for current facts;
   prefer primary sources.
3. **Matrix** — score each candidate against the criteria; note dealbreakers.
4. **PoC plan** — the smallest experiment that would validate the top choice.
5. **Recommendation** — one pick, the reasoning, and the main risk + mitigation.

Flag anything with restrictive licensing, an unclear maintenance future, or
unbounded cost. Save the result as an ADR if the decision is architectural.
