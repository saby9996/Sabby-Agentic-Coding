# Sabby's Agentic Coding Setup — Complete Blueprint

**Target environment:** Claude Code (terminal + VS Code extension), used alongside Cursor and Antigravity, across **macOS, Windows, Ubuntu, and Linux servers**.
**Design principle:** Everything lives in the `.claude` layer so it is IDE- and OS-agnostic — the same setup works whether you launch Claude Code from a plain terminal, VS Code, Cursor, or Antigravity's terminal, on any of those operating systems.
**Packaging:** in this repo the global layer ships as `globalclaude/` (copied to `~/.claude/` by `install.sh` / `install.ps1`), and hooks are **Python 3** so they run identically on every OS. The setup is meant to be shared — see `README.md`.

---

## 1. The Mental Model (read this first)

Claude Code has seven steering methods. Choosing the *wrong layer* is the #1 cause of messy setups. The decision table:

| You want... | Use | Why |
|---|---|---|
| Facts Claude should always know (build cmds, repo layout, conventions) | `CLAUDE.md` | Loaded at session start, survives compaction |
| Hard constraints scoped to certain files ("all API handlers validate with Zod") | `.claude/rules/` with `paths:` frontmatter | Loads only when those files are touched |
| A reusable multi-step procedure (release checklist, migration workflow) | `.claude/skills/` | Name+description load at start; body loads on invoke |
| Delegated side-work that would pollute context (deep search, log audit) | `.claude/agents/` (subagents) | Runs in isolated context; only summary returns |
| Something that must happen *every time*, no model discretion (format after edit, block dangerous cmds) | Hooks in `settings.json` | Deterministic, fires on lifecycle events |
| Global personality/format tweaks | `--append-system-prompt` or output style | Use sparingly; custom output styles replace default coding instructions |

**Rules of thumb:**
- "Every time X, do Y" in CLAUDE.md → move it to a **hook**.
- "Never do this" in CLAUDE.md → move it to a **hook or permission deny rule** (instructions can be ignored under pressure; hooks can't).
- A 30-line procedure in CLAUDE.md → move it to a **skill**.
- Keep root CLAUDE.md **under ~200 lines**. It's an index, not an encyclopedia.

---

## 2. Two-Layer Architecture

### Layer A — Global: `~/.claude/` (your personal defaults, every project)

> In this package the global layer is the folder `globalclaude/`. The installer
> copies it to `~/.claude/`. It also ships `CLAUDE.sabby.example.md` (the
> author's filled-in reference) alongside a neutral, commented `CLAUDE.md`
> template so friends can adopt it and edit only the marked personal blocks.

```
~/.claude/
├── CLAUDE.md                  # Personal, cross-project preferences (~50 lines max)
├── CLAUDE.sabby.example.md    # Worked example of a filled-in CLAUDE.md (reference)
├── settings.json              # Global permissions, hooks, statusline, model, enabled plugins
├── rules/
│   ├── git-discipline.md      # Semantic commits, never force-push main, etc.
│   └── secrets.md             # Never read/print .env values, never commit secrets
├── skills/
│   ├── plan-first/            # Your personal "spec before code" workflow
│   ├── research-tech/         # Structured technology-evaluation workflow
│   ├── adr/                   # Architecture Decision Record generator
│   └── debug-protocol/        # Reproduce → isolate → hypothesize → fix → verify
├── agents/
│   ├── code-reviewer.md       # Reviews diffs: correctness, security, perf
│   ├── architect.md           # System design, trade-off analysis (opus/high effort)
│   ├── test-runner.md         # Runs tests, triages failures, reports summary
│   ├── docs-writer.md         # READMEs, API docs, runbooks
│   ├── security-auditor.md    # OWASP pass, dependency audit, secret scan
│   └── deep-researcher.md     # Web/doc research, returns synthesized brief
├── hooks/                     # Python 3 scripts referenced by settings.json (cross-platform)
│   ├── format_on_edit.py
│   ├── block_dangerous.py
│   ├── notify_done.py
│   └── statusline.py
└── plugins/                   # Managed by /plugin, don't hand-edit
```

**Why Python hooks (not bash `.sh`):** one source file runs on macOS, Windows,
and Linux with only a Python 3 interpreter — no bash, no `jq`. Windows-native
sessions work without WSL/Git Bash. The installer wires `settings.json` to the
right interpreter (`python3` on Unix; `python`/`py` on Windows).

### Layer B — Per Project: `<repo>/.claude/`

```
my-project/
├── CLAUDE.md                  # Project facts: stack, commands, layout, gotchas
├── .claude/
│   ├── settings.json          # Project permissions (checked into git)
│   ├── settings.local.json    # Your machine-only overrides (gitignored)
│   ├── rules/
│   │   ├── api.md             # paths: ["src/api/**"] — API conventions
│   │   ├── db.md              # paths: ["migrations/**"] — migrations append-only
│   │   └── frontend.md        # paths: ["app/**", "components/**"]
│   ├── skills/
│   │   ├── add-endpoint/      # "How we add a FastAPI endpoint here"
│   │   ├── add-migration/     # Supabase migration workflow
│   │   └── release/           # Deploy checklist for this project
│   └── agents/                # Project-specific subagents (only if needed)
├── src/
│   └── api/CLAUDE.md          # Optional: subdirectory context, loads on-demand
└── .mcp.json                  # Project-scoped MCP servers (checked in)
```

**What goes where:** personal preferences → global; team/project facts → project; machine secrets → `settings.local.json` / env vars.

---

## 3. CLAUDE.md Templates

### Global `~/.claude/CLAUDE.md`

```markdown
# Working With Me

## Who I am
Senior software architect. Full-stack (frontend, backend, DB), system design,
AI/LLM development. Assume expert level — skip beginner explanations.

## How I work
- Plan before code on anything non-trivial. Present the plan; wait for my OK
  on architectural decisions.
- Prefer boring, proven solutions. No speculative abstraction.
- Small, reviewable diffs. Don't touch files outside the task scope.
- If an assumption is needed, state it explicitly instead of guessing silently.

## Code style (all projects)
- Python: type hints everywhere, ruff for lint+format, pytest
- TypeScript: strict mode, no `any` without a comment justifying it
- Commits: conventional commits (feat/fix/chore/refactor/docs)

## Communication
- English or Korean — match whichever I use.
- Be direct about problems. Don't tell me a bad idea is good.
```

### Project `CLAUDE.md` (example: Nairomi)

```markdown
# Nairomi — Personal AI Executive Assistant

## Stack
Python 3.12 + FastAPI · Supabase (DB + auth) · Railway hosting
Claude Sonnet (tool use) · Twilio WhatsApp · Discord Bot · Kakao Chatbot API
Gmail API (OAuth2) · Hiworks (IMAP/SMTP) · Google Calendar MCP · Jira (DRLM)

## Commands
- Run dev:      uv run fastapi dev src/main.py
- Tests:        uv run pytest
- Lint/format:  uv run ruff check --fix && uv run ruff format
- Migrations:   supabase migration new <name> && supabase db push

## Layout
src/
  api/        FastAPI routers (one file per channel/domain)
  services/   business logic — channels, email, calendar, jira
  brain/      LLM orchestration, tool definitions, prompts
  models/     pydantic models + DB schemas
  workers/    background jobs (email polling, briefings)

## Critical invariants
- Friend data isolation is absolute: every query MUST filter by user_id (RLS on).
- Jira operations target project DRLM only.
- Email sends ALWAYS require explicit confirmation flow before dispatch.
- No financial/credit-card features — out of scope by design.

## Gotchas
- Hiworks has no OAuth — IMAP/SMTP creds live in env vars only.
- Kakao chatbot callbacks must respond < 5s or Kakao retries.
```

---

## 4. Rules (`.claude/rules/`)

Path-scoped hard conventions. Examples:

**`~/.claude/rules/secrets.md`**
```markdown
Never print, log, or commit the contents of .env files, API keys, or tokens.
When a secret is needed, reference the env var name only.
```

**`project/.claude/rules/db.md`**
```markdown
---
paths:
  - "supabase/migrations/**"
---
Migrations are append-only. Never edit an applied migration; create a new one.
Every table must have RLS enabled with a user_id isolation policy before merge.
```

**`project/.claude/rules/api.md`**
```markdown
---
paths:
  - "src/api/**"
---
All request bodies validated with Pydantic models — no raw dict access.
Every endpoint: explicit response_model, error handling via HTTPException,
and an entry in the router-level test file.
```

---

## 5. Skills — What to Install vs. What to Build

> **Actually installed & enabled in this setup** (see `settings.json`
> `enabledPlugins`, and `plugins-install.sh` / `.ps1` to reproduce):
> `pyright-lsp`, `typescript-lsp`, `jdtls-lsp`, `clangd-lsp`, `code-review`,
> `security-guidance`, `commit-commands`, `frontend-design`, `skill-creator`
> (all `@claude-plugins-official`), plus `superpowers@superpowers-marketplace`
> (marketplace `obra/superpowers-marketplace`) and `claude-mem@thedotmack`
> (marketplace `thedotmack/claude-mem`). **Claude Mem and gstack
> plan-eng-review are required** (see INSTALL-GUIDE Steps 3 and 4.5). The table
> below is the broader catalogue to pick from; the rest are optional.

### Install first (official marketplace: `/plugin install <name>@claude-plugins-official`)

| Plugin/Skill | What it does |
|---|---|
| **Language server (Python / TypeScript)** | Real LSP: go-to-def, references, live type errors after edits. Highest-leverage install for a typed/large codebase. |
| **code-review** | Structured diff review playbook (`/code-review`) |
| **security-guidance** | Security review patterns baked in |
| **commit-commands** | Clean conventional-commit workflow |
| **pr-review-toolkit** | PR-level review workflows |
| **frontend-design** | Distinctive UI output instead of generic AI-slop styling |
| **skill-creator** | Meta-skill: helps you author your own skills properly |
| **feature-dev** | Anthropic's structured feature-development workflow |
| **code-simplifier** | Anthropic-internal cleanup pass: removes duplication, flattens nesting, never changes behavior |

### Strong community options (add their marketplaces first)

| Plugin | Why |
|---|---|
| **Superpowers** (obra) | Full plan → spec → test → implement discipline; the most popular workflow plugin |
| **Context7** | Pulls *current* library docs on demand — kills stale-API hallucinations |
| **Claude Mem** | Persistent cross-session memory |
| **Playwright / webapp-testing** | Lets Claude actually verify UI changes in a browser |

Browse more: `claude.com/plugins`, `ComposioHQ/awesome-claude-skills`, `travisvn/awesome-claude-skills`.

### Build yourself (custom skills)

Each is a folder with `SKILL.md` (frontmatter: `name`, `description`; the description is what triggers auto-invocation, so write it carefully).

1. **`plan-first`** — Your spec-before-code ritual: restate the task, list assumptions, propose approach + alternatives, get approval, then implement.
2. **`research-tech`** — Technology evaluation: criteria matrix, maturity/community/licensing check, PoC plan, recommendation with trade-offs. (Matches your research workflow.)
3. **`adr`** — Generate an Architecture Decision Record into `docs/adr/NNNN-title.md` with context, options, decision, consequences.
4. **`debug-protocol`** — Reproduce → minimize → hypothesize → instrument → fix → add regression test. Prevents shotgun debugging.
5. **`add-endpoint`** (per project) — The exact steps for adding an endpoint in *this* repo: router file, service, model, test, OpenAPI check.
6. **`release`** (per project) — Deploy checklist: tests green, migration status, env diff, tag, deploy, smoke test, rollback plan.
7. **`llm-eval`** — For your AI work: prompt-change checklist, eval-set run, regression comparison before shipping prompt/model changes.

Skill skeleton:

```markdown
---
name: plan-first
description: Use before implementing any non-trivial feature or refactor.
  Produces a short spec and waits for approval before writing code.
---

# Plan First

1. Restate the task in one paragraph. List explicit assumptions.
2. Identify affected files/modules. Note anything out of scope.
3. Propose the approach. If there's a real alternative, show both with trade-offs.
4. List risks and how they'll be verified (tests, manual checks).
5. STOP and present the plan. Do not write code until approved.
```

---

## 6. Subagents (`~/.claude/agents/`)

Each `.md` file's body is that agent's **system prompt** (not a user prompt — most common mistake). Frontmatter can pin `model` and `tools`.

**`code-reviewer.md`**
```markdown
---
name: code-reviewer
description: Reviews a diff or PR for correctness, security, performance,
  and maintainability. Use after implementing a feature, before commit.
tools: Read, Grep, Glob, Bash
---
You are a principal engineer doing code review. Review ONLY the provided diff.
Check in order: (1) correctness & edge cases, (2) security — injection, authz,
secrets, SSRF, (3) performance — N+1, unbounded loops, blocking I/O in async,
(4) readability & convention adherence. Output: blocking issues first, then
suggestions, then nitpicks. Cite file:line for every finding. Do not edit files.
```

**`architect.md`**
```markdown
---
name: architect
description: System design and architecture trade-off analysis. Use for new
  services, data models, integration design, or "how should we structure X".
model: opus
---
You are a systems architect. Produce: context, constraints, 2–3 candidate
designs with trade-offs (consistency, cost, operational load, failure modes),
a recommendation, and open questions. Prefer boring technology. Flag anything
that creates single points of failure or unbounded cost.
```

**`test-runner.md`**
```markdown
---
name: test-runner
description: Runs the test suite, triages failures, and returns a concise
  summary. Use whenever verification is needed.
tools: Bash, Read, Grep
---
Run the project's test command (from CLAUDE.md). If failures: group by root
cause, show the minimal relevant traceback per group, identify whether the
failure is the new code or a pre-existing issue. Return a summary — never
paste full logs into your final answer.
```

**`security-auditor.md`**
```markdown
---
name: security-auditor
description: Security audit of code, dependencies, and configuration.
  Use before releases or after auth/data-handling changes.
tools: Read, Grep, Glob, Bash
---
Perform: (1) secret scan of tracked files, (2) dependency audit (pip-audit /
npm audit), (3) OWASP top-10 pass on changed code, (4) authz check — every
data access filtered by the owning user, (5) config review (CORS, cookies,
headers). Report findings by severity with file:line and a concrete fix each.
```

**`deep-researcher.md`**
```markdown
---
name: deep-researcher
description: Deep technical research on libraries, APIs, patterns, or vendor
  comparisons. Use when current external information is needed.
tools: WebSearch, WebFetch, Read
---
Research the question using primary sources (official docs, changelogs, RFCs)
over blog posts. Return: direct answer, key evidence with links, version/date
caveats, and what you could NOT verify. Max ~400 words.
```

**`docs-writer.md`** — READMEs/runbooks/API docs; write-for-the-reader, examples over prose, never invent behavior not in code.

**Why subagents here and not skills:** these tasks generate noisy intermediate output (test logs, search results, full-file reads) that you don't want burning your main context window. Only the summary comes back.

---

## 7. Hooks (`~/.claude/settings.json`)

Deterministic automation, written in **Python 3** so one source runs on every OS.
The high-value set:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "python3 \"$HOME/.claude/hooks/block_dangerous.py\"" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          { "type": "command", "command": "python3 \"$HOME/.claude/hooks/format_on_edit.py\"" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "python3 \"$HOME/.claude/hooks/notify_done.py\"" }
        ]
      }
    ]
  }
}
```
(On Windows the installer rewrites `python3` to `python`/`py`.)

**`block_dangerous.py`** — read the tool-input JSON from stdin; exit code 2 (with
a message on stderr) blocks the call. Blocks `rm -rf /`, force-push, direct push
to main/master, `DROP/TRUNCATE`, `curl | bash`, `sudo`, `chmod -R 777`, `DELETE`
without `WHERE`, and writes to `.env`. Fails open (exit 0) on any parse error so
it can never break a normal session — the `settings.json` deny-list is the real
gate; this is a second pattern-based layer.

**`format_on_edit.py`** — run `ruff format` / `prettier` on the edited file based
on extension (via `shutil.which`, so missing tools just skip). The formatter
*running automatically* beats the model *choosing* to run it.

**`notify_done.py`** — cross-platform desktop notification when a turn finishes:
osascript (macOS) / notify-send (Linux) / BurntToast toast or beep (Windows) /
stderr line (headless server). Includes the cwd so parallel sessions are
distinguishable.

**`statusline.py`** — renders `dir ⎇ branch ⟨model⟩` at the bottom of the UI.

Optional extras: `PreCompact` hook to back up the transcript; `SessionStart` hook to inject `git status`/branch context.

---

## 8. Permissions (`settings.json`)

Deny > Ask > Allow. Sensible default for a solo power user:

```json
{
  "permissions": {
    "allow": [
      "Bash(uv run *)",
      "Bash(npm run *)",
      "Bash(git status)", "Bash(git diff *)", "Bash(git log *)",
      "Bash(git add *)", "Bash(git commit *)",
      "Read(**)", "Edit(**)", "Write(**)"
    ],
    "ask": [
      "Bash(git push *)",
      "Bash(supabase db push)",
      "Bash(railway *)",
      "WebFetch"
    ],
    "deny": [
      "Read(./.env)", "Read(./.env.*)", "Read(**/secrets/**)",
      "Bash(curl * | bash)", "Bash(sudo *)"
    ]
  }
}
```

Tune per project in `<repo>/.claude/settings.json`. Note `deny` on reading `.env` is a real guardrail against prompt-injection exfiltration, not just tidiness.

---

## 9. MCP Servers

Project-scoped in `<repo>/.mcp.json` (checked in), personal ones via `claude mcp add --scope user`.

**Recommended for you:**

| Server | Use |
|---|---|
| **GitHub** | PRs, issues, CI status without leaving the session |
| **Atlassian** | Jira DRLM task creation/updates — core to Nairomi and your workflow |
| **Supabase** | Inspect schema, run queries, manage migrations in-session |
| **Context7** | Live, version-accurate library docs |
| **Playwright** | Browser-verify frontend changes |
| **Sentry** (when you have prod) | Pull real errors into debugging sessions |

**MCP discipline:** every connected server's tool definitions cost context in every session. Connect what the *project* needs in `.mcp.json`, keep the global list minimal, and disable unused servers rather than accumulating them. Treat third-party MCP servers as a supply-chain surface — only well-known publishers.

---

## 10. Build Order — Step by Step

**Phase 1 — Foundation (Day 1, ~1 hour)**
1. `mkdir -p ~/.claude/{rules,skills,agents,hooks}`
2. Write global `CLAUDE.md` (template above; keep it ≤50 lines).
3. Write `settings.json` with the permission set. Test with a scratch repo.
4. Install: your two LSP plugins + `code-review` + `commit-commands` from `claude-plugins-official`.

**Phase 2 — Guardrails (Day 1–2)**
5. Add the three hooks (block-dangerous, format-on-edit, notify-done). Verify block-dangerous actually blocks (`echo` a denied pattern).
6. Add `rules/secrets.md` and `rules/git-discipline.md`.

**Phase 3 — Project layer (per repo, ~30 min each)**
7. In each active repo: run `/init` to draft `CLAUDE.md`, then **edit it down** to the template shape — commands, layout, invariants, gotchas.
8. Add path-scoped rules for API/DB/frontend zones.
9. Add `.mcp.json` with only the servers that repo needs.

**Phase 4 — Skills (Week 1)**
10. Install `skill-creator`, then build `plan-first`, `debug-protocol`, `adr`, `research-tech` globally.
11. Build `add-endpoint` + `release` inside your main project. Rule: the third time you type the same instructions, it becomes a skill.

**Phase 5 — Subagents (Week 1–2)**
12. Add `code-reviewer`, `test-runner` first (highest frequency). Then `architect`, `security-auditor`, `deep-researcher`, `docs-writer`.
13. Wire the habit: implement → invoke test-runner → invoke code-reviewer → commit.

**Phase 6 — Iterate forever**
14. When Claude does something wrong twice, ask: was it missing a **fact** (CLAUDE.md), a **procedure** (skill), a **constraint** (rule/hook), or should it have been **delegated** (subagent)? File the fix in the right layer.
15. Prune quarterly. Instructions dilute each other — every line must earn its place.
16. When the setup stabilizes, bundle it as a personal **plugin** so it's versioned and portable.

---

## 11. Anti-Patterns to Avoid

- **Mega-CLAUDE.md.** 500-line context files reduce adherence to everything.
- **Instructions as guardrails.** "Never drop the DB" in markdown ≠ safety. Hooks/permissions are the only real enforcement.
- **Agent sprawl.** 15 subagents whose descriptions overlap → wrong agent gets picked. 5–7 sharply-scoped agents beat 15 vague ones.
- **MCP hoarding.** Every server's tools cost tokens every session.
- **Custom output styles casually.** They *replace* Claude Code's default engineering instructions (scoping, testing habits, security behavior) unless you set `keep-coding-instructions: true`. Prefer `--append-system-prompt` or the built-in Proactive/Explanatory/Learning styles.
- **Skipping verification loops.** The setup's real power is the loop: edit → hook formats → test-runner verifies → reviewer critiques. Agents without verification are just fast typo generators.

## 12. Portability & Sharing

This setup is built to run on many machines and be handed to friends.

- **One package, five OSes.** The global layer is `globalclaude/`; `install.sh`
  (macOS/Linux/servers) and `install.ps1` (Windows) copy it to `~/.claude/`,
  set exec bits, back up any prior install, and on Windows patch the hook
  interpreter (`python`/`py`). `plugins-install.sh` / `.ps1` reproduce the exact
  plugin set via the `claude plugin` CLI.
- **Python hooks = single source.** No per-OS shell dialects, no `jq`. Only a
  Python 3 interpreter is required (already present on any dev box). Missing
  Python degrades gracefully — hooks skip, the deny-list still guards.
- **Personal vs framework split.** `CLAUDE.md` ships as a neutral, commented
  template; only the `<<EDIT>>` blocks (identity, language, stack) are personal.
  The rest — autonomy contract, verification bar, guardrail, slash commands — is
  reused verbatim. The author's real file is preserved as
  `CLAUDE.sabby.example.md` for reference.
- **No secrets travel.** Nothing in the package contains credentials. `.env`
  reads are denied by permissions *and* the guardrail hook, so sharing the folder
  never leaks anything.
- **Sync strategy.** Put the package in a private git repo; on a new machine
  `git clone` + run the installer. Re-run the installer after pulling updates
  (it backs up first). For per-project layers, commit the repo's `.claude/` so
  collaborators inherit the same rules.

**Reproducibility checklist for a new machine (or a friend):**
1. Install Claude Code + sign in; ensure `python3` (or `python`) is on PATH.
2. `./install.sh` (or `install.ps1`).
3. `./plugins-install.sh` (or `.ps1`); install LSP binaries for your languages.
4. Edit the `<<EDIT>>` blocks in `~/.claude/CLAUDE.md`.
5. In each repo, drop in `project-template/` and fill `CLAUDE.md`.

---

## References
- Steering guide: claude.com/blog/steering-claude-code-skills-hooks-rules-subagents-and-more
- Docs: code.claude.com/docs (skills, sub-agents, hooks, settings, plugins, memory)
- Best practices: code.claude.com/docs/en/best-practices
- Plugin directory: claude.com/plugins
