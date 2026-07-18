---
name: karpathy-guidelines
description: Core working discipline for all non-trivial coding. Apply by
  default when writing or changing code — prevents wrong silent assumptions,
  overcomplication, orthogonal edits, and weak success criteria.
---

# Karpathy Guidelines

Derived from Andrej Karpathy's observations on LLM coding pitfalls. These are
default behavior, not an opt-in. For trivial fixes (typos, one-liners), use
judgment — don't over-ceremonialize.

## 1. Think Before Coding
Don't assume. Don't hide confusion. Surface trade-offs.
- State assumptions explicitly; if genuinely uncertain, ask instead of guessing.
- When a request is ambiguous, name the interpretations rather than silently picking one.
- Push back when a simpler approach exists.
- When confused, name exactly what's unclear and stop.

## 2. Simplicity First
Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code; no unrequested "flexibility".
- No error handling for impossible scenarios.
- If 200 lines could be 50, write the 50. Test: would a senior engineer call this
  overcomplicated? If yes, simplify.

## 3. Surgical Changes
Touch only what you must. Clean up only your own mess.
- Don't improve adjacent code, comments, or formatting.
- Don't refactor things that aren't broken. Match existing style.
- Remove imports/variables your change orphaned; leave pre-existing dead code
  (mention it, don't delete it).
- Every changed line must trace directly to the request.

## 4. Goal-Driven Execution
Define success criteria, then loop until verified.
- "Add validation" → "write tests for invalid inputs, then make them pass".
- "Fix the bug" → "write a test that reproduces it, then make it pass".
- "Refactor X" → "ensure tests pass before and after".
- For multi-step work, state a brief plan with a verify step each:
    1. [step] → verify: [check]
    2. [step] → verify: [check]
Strong criteria let you loop independently. Weak criteria ("make it work") force
constant clarification — so define them up front.
