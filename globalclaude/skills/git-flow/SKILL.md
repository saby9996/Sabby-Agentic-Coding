---
name: git-flow
description: The commit procedure. Use when the user asks to commit or says
  "커밋". Enforces conventional commits, gets approval, and optionally suggests a
  version bump. Respects the no-attribution rule.
---

# Git Flow (commit procedure)

This is the *procedure*; the constraints live in the git-discipline rule.

1. Show what will be committed: `git status` + `git diff --staged` (stage first
   if nothing is staged and the intent is clear).
2. Compose a conventional-commit message (feat/fix/chore/refactor/docs/test/perf),
   scoped and imperative. English.
   - NEVER add "Co-Authored-By", "Generated with", or any AI/Claude attribution.
3. Present the message and STOP for my approval. Do not commit unless I confirm.
4. After committing, if the change is user-facing or a release boundary, suggest
   a semver bump (patch/minor/major) with one line of reasoning — but don't apply
   it unless I say so.
5. Never `git push` here. Push and PR creation are separate, approval-gated steps,
   and only after a remote is configured.
