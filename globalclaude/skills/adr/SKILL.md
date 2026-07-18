---
name: adr
description: Generate an Architecture Decision Record. Use after any significant
  architecture or technology decision is made.
---

# ADR Generator

Write to `docs/adr/NNNN-short-title.md` (zero-padded, next number in sequence).

Template:
```
# NNNN. <Title>

- Status: Proposed | Accepted | Superseded by NNNN
- Date: YYYY-MM-DD

## Context
What problem/force prompted this decision. Constraints in play.

## Options Considered
1. <Option> — pros / cons
2. <Option> — pros / cons

## Decision
What we chose and why.

## Consequences
What becomes easier, what becomes harder, what we're now committed to,
and what we'll need to revisit.
```
Keep it tight. An ADR records a decision; it is not a design doc.
