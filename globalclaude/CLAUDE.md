<!--
============================================================================
  GLOBAL CLAUDE.md  ·  loaded at the start of EVERY Claude Code session
============================================================================
This is your personal, cross-project operating manual for Claude Code. It lives
at ~/.claude/CLAUDE.md and applies in every repo, in every IDE (terminal, VS
Code, Cursor, Antigravity — they all read this same file).

HOW TO USE THIS FILE (friends, read this):
  • Sections marked  <<EDIT>>  are personal — change them to describe YOU.
  • The other sections (Autonomy, Verification bar, Slash commands, Git, Memory)
    are the reusable "framework" — safe to keep verbatim; they're what make the
    whole setup behave consistently.
  • Keep this file UNDER ~200 lines. It is an index, not an encyclopedia. Facts
    that belong to one project go in that repo's CLAUDE.md instead.
  • Want the author's real, filled-in version as a reference? See the file
    CLAUDE.sabby.example.md sitting next to this one.
============================================================================
-->

# Working With Me

## Who I am   <<EDIT — describe yourself>>
<!-- One short paragraph. Your role, seniority, and what to ASSUME about you so
     Claude skips the wrong altitude of explanation. Example below — replace it. -->
Senior software engineer. Full-stack (frontend, backend, DB) plus system design.
Assume expert level — skip beginner explanations and boilerplate hand-holding.

<!-- OPTIONAL: list your active projects/domains so Claude has context. Keep it
     to a couple of lines; project specifics belong in each repo's CLAUDE.md. -->
Active domains: <e.g. web apps, data pipelines, an AI assistant>. Breadth is
high, so lean on project-level CLAUDE.md for specifics.

## Autonomy contract   <<keep — this is the framework>>
- **Free rein on implementation.** Once an approach is agreed, implement fully
  without stopping for line-by-line approval.
- **Stop only at architectural decision points**: new service boundaries, data
  model changes, dependency additions, public API/contract changes, anything
  irreversible or cross-cutting. At those points, present options + trade-offs
  and wait.
- Everything in `karpathy-guidelines` applies by default: think before coding,
  simplicity first, surgical changes, goal-driven execution.

## Verification bar (before anything is "done")   <<keep>>
Order: **check → tests → code-review → manual.** A change is not complete until:
(1) the `check` gate (typecheck + lint) passes, (2) tests pass, (3) the
`code-reviewer` subagent has reviewed the diff, (4) it's ready for your manual
review. Do not report a task finished until steps 1–3 have actually run.

## Slash command registration   <<keep>>
When I type `/plan`, `/implement`, `/check`, `/loop`, `/ship`, `/commit`,
`/remember`, or `/adr`, invoke the matching skill via the Skill tool before
doing anything else. Treat these as explicit entry points, not hints.
(`/code-review` belongs to the official code-review plugin and triggers its own
skill.)

## Project memory (docs/Memory.md + docs/Index.md)   <<keep>>
Repos keep a durable memory ledger via the memory-docs skill. After any
significant decision, gotcha, or incident fix, proactively offer to record it
(or just record it when I say "remember this"). Consult docs/Index.md when
starting non-trivial work in a repo to check for relevant prior context.

## Git   <<keep — tune to taste>>
- Conventional commits (feat/fix/chore/refactor/docs/test).
- **Never add "Co-Authored-By" or any Claude/AI attribution to commits.**
- Commit messages in English.
- `git push` and PR creation: ask first, then do. Assume no remote exists until
  I say a remote is configured.
- Repos may have collaborators — respect existing style, don't drive-by refactor.

## Language   <<EDIT — your languages>>
<!-- Tell Claude which language to answer/commit/write docs in. Example: -->
- My prompts are in English. Commits and code comments: English.
- User-facing docs: English by default; other languages when I ask.

## Stack defaults (override per project)   <<EDIT — your default stack>>
<!-- Your go-to stack so Claude doesn't guess. Each repo's CLAUDE.md overrides. -->
- Frontend: React + TypeScript + Vite (strict mode, no `any` without a comment)
- Backend: Python (type hints everywhere, ruff, pytest) unless the repo differs
- Prefer boring, proven solutions. No speculative abstraction.

## Communication   <<keep — tune to taste>>
- Be direct. If an idea is bad, say so and say why. Don't validate weak plans.
- Surface trade-offs and inconsistencies instead of silently picking one.
