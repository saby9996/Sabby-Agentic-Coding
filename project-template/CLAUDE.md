<!-- PROJECT CLAUDE.md — copy this file to a repo root and fill in the <angle>
     placeholders. This is per-project facts (stack, commands, layout, rules);
     your personal preferences live in the global ~/.claude/CLAUDE.md instead.
     Keep it tight — Claude loads it every session in this repo. -->

# <Project Name>

## Stack
<languages, frameworks, DB, hosting, key services>

## Commands
- Run dev:      <cmd>
- Tests:        <cmd>
- Lint/format:  <cmd>
- Build:        <cmd>

## Layout
<top-level dirs and what lives in each — keep to ~10 lines>

## Critical invariants
- <non-negotiables: isolation rules, append-only migrations, confirm-before-send, etc>

## Gotchas
- <the surprising stuff that bites: auth quirks, timeouts, env-only creds>

## Success criteria for common tasks
- New feature: <the check command that proves it works>

## Project memory
Durable decisions/learnings live in `docs/Memory.md` (full entries, append-only)
with `docs/Index.md` as the line-ranged index. Check Index.md before non-trivial
work; record new entries via the memory-docs skill (/remember).
