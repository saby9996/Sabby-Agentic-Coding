# Project Memory

Append-only ledger of decisions, learnings, gotchas, and context worth keeping.
Every entry gets a full description here; a 1–2 line summary lives in Index.md
with a pointer back to this file's line range.

RULES
- Append-only: never edit or delete past entries (so line numbers stay stable).
  To supersede an entry, add a NEW entry and mark the relationship.
- Entry IDs are sequential: M-001, M-002, ...
- Every entry MUST be mirrored in Index.md with its line range.

FORMAT (copy for each new entry)
--------------------------------
## M-000 · <Title> · YYYY-MM-DD
- Type: decision | learning | gotcha | convention | incident
- Status: active | superseded-by M-XXX
- Tags: <comma, separated>

<Full description: context, what was decided/learned, why, alternatives
considered, consequences. As many lines as needed.>
--------------------------------

<!-- ENTRIES BEGIN BELOW. Do not modify anything above this line. -->

## M-001 · Memory system established · 2026-07-18
- Type: convention
- Status: active
- Tags: meta, docs

This file and Index.md were created to keep a durable, human-readable project
memory alongside code. Full descriptions live here; Index.md carries a 1–2 line
summary per entry plus the line range in this file where the entry lives.
Maintained via the memory-docs skill (append-only; index regenerated on write).
