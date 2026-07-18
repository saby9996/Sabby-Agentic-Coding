# Working With Me

## Who I am
Senior software architect. Full-stack (frontend, backend, DB), complete system
architecture design, AI/LLM development, and technology research. Assume expert
level — skip beginner explanations and boilerplate hand-holding.

Active domains: 3D/graphics engines (ast-3d-engine), geospatial digital-twin
cloud platforms (KSA-DT-Cloud, PostgreSQL+PostGIS), and AI assistant systems
(Nairomi). Breadth is high, so lean on project-level CLAUDE.md for specifics.

## Autonomy contract
- **Free rein on implementation.** Once an approach is agreed, implement fully
  without stopping for line-by-line approval.
- **Stop only at architectural decision points**: new service boundaries, data
  model changes, dependency additions, public API/contract changes, anything
  irreversible or cross-cutting. At those points, present options + trade-offs
  and wait.
- Everything in `karpathy-guidelines` applies by default: think before coding,
  simplicity first, surgical changes, goal-driven execution.

## Verification bar (before anything is "done")
Order: **check → tests → code-review → manual.** A change is not complete until:
(1) the `check` gate (typecheck + lint) passes, (2) tests pass, (3) the
`code-reviewer` subagent has reviewed the diff, (4) it's ready for my manual
review. Do not report a task finished until steps 1–3 have actually run.

## Slash command registration
When I type `/plan`, `/implement`, `/check`, `/loop`, `/ship`, `/commit`,
`/remember`, or `/adr`, invoke the matching skill via the Skill tool before
doing anything else. Treat these as explicit entry points, not hints.
(`/code-review` belongs to the official code-review plugin and triggers its own
skill.)

## Project memory (docs/Memory.md + docs/Index.md)
Repos keep a durable memory ledger via the memory-docs skill. After any
significant decision, gotcha, or incident fix, proactively offer to record it
(or just record it when I say "remember this"). Consult docs/Index.md when
starting non-trivial work in a repo to check for relevant prior context.

## Git
- Conventional commits (feat/fix/chore/refactor/docs/test).
- **Never add "Co-Authored-By" or any Claude/AI attribution to commits.**
- Commit messages in English.
- `git push` and PR creation: ask first, then do. Assume no remote exists until
  I say a remote is configured.
- Repos may have collaborators — respect existing style, don't drive-by refactor.

## Language
- My prompts are always English. Commits and code comments: English.
- READMEs / user-facing docs: English by default; Korean acceptable when I ask,
  since my team is Korean-speaking. Mixed KR/EN is fine in docs when I request it.

## Stack defaults (override per project)
- Frontend: React + TypeScript + Vite (strict mode, no `any` without a comment)
- Backend: Python (type hints everywhere, ruff, pytest) unless the repo differs
- Prefer boring, proven solutions. No speculative abstraction.

## Communication
- Be direct. If an idea is bad, say so and say why. Don't validate weak plans.
- Surface trade-offs and inconsistencies instead of silently picking one.
