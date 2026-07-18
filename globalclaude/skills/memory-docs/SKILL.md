---
name: memory-docs
description: Maintain the project's docs/Memory.md (full entries) and
  docs/Index.md (1–2 line summaries with line ranges). Use after significant
  decisions, learnings, gotchas, or incidents, when the user says "remember
  this" / "add to memory", or via /remember. Also use to look things up in
  project memory.
---

# Memory Docs (Memory.md + Index.md)

Two files under `docs/`:
- **Memory.md** — the ledger. Every entry with its FULL description. Append-only.
- **Index.md** — one entry per memory: `M-ID (Memory.md L<start>–L<end>) — <1–2
  line summary>`. This is the map: Memory lines : Index lines.

If the files don't exist yet, create both from the standard template (header +
rules + `<!-- ENTRIES BEGIN BELOW -->` marker in Memory.md; header +
`<!-- INDEX BEGINS -->` marker in Index.md), then add M-001 recording that the
memory system was established.

## Writing a new entry
1. Read Memory.md; determine the next sequential ID (M-###).
2. **Append** to the end of Memory.md (never insert, never edit old entries —
   line-number stability depends on append-only):

   ```
   ## M-### · <Title> · YYYY-MM-DD
   - Type: decision | learning | gotcha | convention | incident
   - Status: active
   - Tags: <tags>

   <Full description: context, what/why, alternatives considered, consequences.>
   ```
3. Recompute the entry's exact line range with `grep -n '^## M-' docs/Memory.md`
   (start = the entry's header line; end = last line of the file, or the line
   before the next header). Do NOT estimate line numbers — measure them.
4. Append the matching line to Index.md:
   `M-### (Memory.md L<start>–L<end>) — <1–2 line summary>`
   The summary is max 2 lines. If it needs more, it's a description — tighten it.

## Superseding (never deleting)
To change a past decision: write a NEW entry describing the change, set its
predecessor's relationship by noting `supersedes M-XXX` in the new entry's body,
and update ONLY the `Status:` line of the old entry to `superseded-by M-###`
(a same-length single-line edit is the one permitted touch; if it would change
the old entry's line count, don't — note it in the new entry instead). Update
the old entry's index line summary to prefix `[superseded]`.

## Verifying the index (do this whenever you touch these files)
Run `grep -n '^## M-' docs/Memory.md` and confirm every ID appears exactly once
in Index.md with a line range matching the measured positions. If any range has
drifted, regenerate Index.md's entry lines from the measurements. Index.md line
ranges are derived data — Memory.md is the source of truth.

## What belongs in memory
Decisions with reasoning (why X over Y), hard-won gotchas, incident causes and
fixes, conventions adopted mid-project, external constraints discovered
(API quirks, rate limits, data-shape surprises). NOT: routine changes (that's
git history), secrets/credentials (never), or anything already in CLAUDE.md
(link instead of duplicating — put the pointer in the entry).

## Relationship to other memory layers
- CLAUDE.md = always-loaded facts (small, curated).
- docs/Memory.md = durable searchable history (grow freely; loaded on demand).
- Claude Mem = cross-session convenience. If they conflict: CLAUDE.md wins,
  then Memory.md.
When a Memory.md entry becomes something needed in every session, promote a
one-line version to CLAUDE.md and link the M-ID.
