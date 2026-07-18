# Agentic Coding Setup — Install & Usage Guide

*English first. 한국어 안내는 아래 [한국어 설치 가이드](#한국어-설치-가이드)에 있습니다.*

Two deliverables:
- **`globalclaude/`** → becomes your global `~/.claude/` (applies to every project, every IDE).
- **`project-template/`** → copy its contents into each repo's root.

Everything is IDE- and OS-agnostic. Whether you launch Claude Code from a
terminal, the VS Code extension, Cursor, or Antigravity's integrated terminal —
on **macOS, Windows, Ubuntu, or a Linux server** — it reads the same `~/.claude`
and repo `.claude`, so every environment gets the same brain.

> The hooks and status line are written in **Python 3** (single source, runs on
> every OS). Earlier versions used bash `.sh` scripts; those are gone.

---

## Prerequisites

- **Claude Code** installed and signed in (the `claude` CLI on your PATH).
  Subscription set to Opus.
- **Python 3** on PATH — required for the hooks + status line. On macOS/Linux
  it's usually `python3`; on Windows it's `python` or the `py` launcher (the
  Windows installer auto-detects this). If Python is missing the hooks simply
  skip — nothing breaks, and the `settings.json` deny-list remains the gate.
- Optional: `ruff` (Python) and `prettier` (JS/TS) for the format-on-edit hook;
  `git` for the status-line branch. Missing formatters skip silently.
- Note: the files in `globalclaude/` are the authoritative, tested versions.
  Snippets inside `agentic-coding-setup-blueprint.md` are illustrative reading.

---

## Step 1 — Install the global layer

### Option A — one-command installer (recommended)

**macOS / Linux / servers**
```bash
cd "Sabby Agentic AI Setup"
./install.sh
```
**Windows (PowerShell)**
```powershell
cd "Sabby Agentic AI Setup"
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

The installer backs up any existing `~/.claude`, copies `globalclaude/` in,
makes the Python hooks executable, and on Windows patches `settings.json` to use
your local Python command. It finishes by smoke-testing the guardrail hook.

### Option B — manual

```bash
cp -r globalclaude/. ~/.claude/
chmod +x ~/.claude/hooks/*.py     # exec bit isn't preserved in downloads
```

### Verify

```bash
ls ~/.claude                       # CLAUDE.md, settings.json, rules, skills, agents, hooks, commands
# Guardrail smoke test (expect a GUARDRAIL BLOCK line and exit=2):
printf '%s' '{"tool_input":{"command":"git push --force origin main"}}' \
  | python3 ~/.claude/hooks/block_dangerous.py; echo "exit=$?"
```

Start Claude Code in any repo and run `/help`, `/agents`, `/plugin` to confirm
it loaded. Your status line should show `dir ⎇ branch ⟨Opus⟩`.

**Make it yours:** edit `~/.claude/CLAUDE.md` — change only the sections marked
`<<EDIT>>` (Who I am, Language, Stack defaults). The author's filled-in reference
is `CLAUDE.sabby.example.md` next to it.

---

## Step 2 — Install plugins

### Option A — reproducible script

**macOS / Linux**
```bash
./plugins-install.sh
```
**Windows**
```powershell
powershell -ExecutionPolicy Bypass -File .\plugins-install.ps1
```

### Option B — inside Claude Code (the official marketplace is pre-registered)

```
/plugin install pyright-lsp@claude-plugins-official       # Python LSP  (binary: npm i -g pyright)
/plugin install typescript-lsp@claude-plugins-official    # TS/JS LSP   (binary: npm i -g typescript typescript-language-server)
/plugin install jdtls-lsp@claude-plugins-official         # Java LSP    (binary: brew install jdtls; JDK 17+)
/plugin install clangd-lsp@claude-plugins-official        # C/C++ LSP   (binary: clangd via LLVM; needs compile_commands.json)
/plugin install code-review@claude-plugins-official
/plugin install security-guidance@claude-plugins-official
/plugin install commit-commands@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install skill-creator@claude-plugins-official

/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace        # full plan→spec→test workflow

/plugin marketplace add thedotmack/claude-mem              # required — see Step 3
/plugin install claude-mem@thedotmack
```

**This is the exact set this setup ships enabled** (see `enabledPlugins` in
`settings.json`). The four LSPs are connectors only — install the language-server
**binary first**, then the plugin, then `/reload-plugins`. Test with "go to
definition of X": instant `file:line` + `LSP` in the output = working; grepping =
not connected. `jdtls-lsp` needs a JDK 17+ and the `jdtls` binary; `clangd-lsp`
needs `clangd` (from LLVM) and a `compile_commands.json` in the project.

Other official LSPs (same pattern, install only for languages you use):
`gopls-lsp`, `rust-analyzer-lsp`, `csharp-lsp`, `kotlin-lsp`, `swift-lsp`,
`php-lsp`, `ruby-lsp`. On huge projects pyright/rust-analyzer/jdtls can be
RAM-heavy — `/plugin disable <name>` to fall back.

Context7 (fresh library docs) and Playwright (browser verification) are wired
**per-project** via `.mcp.json` (Step 4), not as plugins.

---

## Step 3 — Claude Mem (required: cross-session memory)

Claude Mem gives Claude Code persistent memory across sessions — it captures what
happened, compresses it, and injects relevant context into future sessions.
Install it (already in `plugins-install.sh` / `enabledPlugins`):

```
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@thedotmack
```
Then restart Claude Code. (Alternative CLI install: `npx claude-mem install`.
Do **not** use `npm i -g claude-mem` — that installs the SDK only and does not
register the plugin hooks.)

Two rules given this setup:
- Keep durable project facts in `CLAUDE.md` (source of truth) and let Claude Mem
  hold softer cross-session context. If a "remembered" fact conflicts with
  `CLAUDE.md`, **`CLAUDE.md` wins**.
- With parallel sessions, memory is shared across them — prune occasionally so
  stale context from one project doesn't bleed into another.

---

## Step 4 — Per-project layer (do this in each repo)

```bash
cp -r "/path/to/Sabby Agentic AI Setup/project-template/." .   # copies CLAUDE.md, .claude/, .mcp.json
```
Then:
1. Fill in `CLAUDE.md` — stack, commands, layout, invariants, gotchas, and the
   **success-criterion command** for common tasks (the loop-runner needs it).
2. Edit the path-scoped rules in `.claude/rules/` to match the repo, or delete
   ones that don't apply. (The shipped `frontend.md` globs are intentionally
   front-end-only — widen them to your layout.)
3. Trim `.mcp.json` to the servers that repo needs. Add the GitHub MCP only
   after you've set up the remote.
4. **If the repo has collaborators:** commit `CLAUDE.md`, `.claude/rules/`,
   `.claude/settings.json`, and `.mcp.json`. Keep `settings.local.json` and
   `.claude/loop/` gitignored (machine-local / scratch).

Suggested repo `.gitignore` additions:
```
.claude/settings.local.json
.claude/loop/
```

Tip: instead of copying by hand, run Claude Code's `/init` in a new repo to draft
`CLAUDE.md`, then paste your template's invariants/gotchas over it.

The template also ships `docs/Memory.md` + `docs/Index.md` — a durable project
memory ledger. Memory.md holds full append-only entries (M-001, M-002, …);
Index.md holds a 1–2 line summary per entry with the exact line range. Maintained
by the `memory-docs` skill: say "remember this" or `/remember <thing>` and Claude
appends the entry and re-measures the index line ranges (never estimates them).
Commit both files — they're valuable to human collaborators too.

---

## Step 4.5 — gstack plan-eng-review (required)

An engineering-perspective review of your plan doc (architecture, edge cases,
test coverage) that slots between `/plan` and implementation. From a separate MIT
repo (gstack, Garry Tan) with its own `bin/` scripts, so it must be installed
with its official installer (copying files won't work).

Requirements: Git, Bun v1.0+ (Windows also needs Node.js). In Claude Code:
```
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack \
  && cd ~/.claude/skills/gstack && ./setup
```
Then `/plan-eng-review` reviews a plan (also installs `/review`, `/qa`,
`/investigate`). Run it after `/plan`, before you turn a plan loose.

---

## Step 5 — Your daily workflow (the loop)

Your autonomy contract, verification bar, and loop discipline are all wired in.
A typical non-trivial task:

1. `/plan <task>` — plan-first spec. Stops only at an architectural decision
   (new service, schema change, new dep, public contract); otherwise proceeds.
2. *(optional)* `/plan-eng-review` — engineering review of the plan (gstack).
3. Implement:
   - **Default: free rein.** Let it implement directly (karpathy-guidelines keep
     changes simple and surgical). Best for small/medium changes.
   - **Larger feature: `/implement <task>`** — routes to specialist agents
     (architect → logic-expert / ui-publisher) with an `evaluator` self-check
     loop, keeping logic and UI as separate legible diffs.
4. `/check` — fast typecheck + lint gate. Cheap; catches trivial breakage early.
5. `/loop <success-criterion>` — for anything with a checkable goal (tests pass,
   type errors gone, an e2e flow green). Loops until the criterion command exits
   0, with runaway guards.
6. `/ship` — full verification bar: check → test-runner → code-reviewer →
   (security-auditor if auth/data touched). Reports ready for your manual review.
7. `/commit` — git-flow: conventional message, waits for approval, never
   attributes to Claude, suggests a version bump at release boundaries.
   `git push`/PR are separate approval-gated steps, only after a remote exists.

Parallel sessions: use `git worktree add ../repo-feature-x feature-x` so each
Claude session works in its own directory/branch. The notify-done hook tells you
which one finished (it prints the dir name).

---

## Step 6 — Keep it healthy

When Claude gets something wrong twice, classify the fix by layer:
- Missing **fact** → add to `CLAUDE.md` (keep it <200 lines).
- Missing **procedure** → new/updated **skill**.
- Missing **constraint** → **rule** (path-scoped) or **hook** (if it must be deterministic).
- Should've been **delegated** → new/tuned **subagent**.

Prune quarterly. Every line of always-loaded context dilutes the rest. When
stable, bundle your `skills/ agents/ hooks/ commands/` into a personal **plugin**
so it's versioned and portable across machines.

---

## Cross-platform reference

| OS | Install | Hook interpreter | Notifications |
|---|---|---|---|
| macOS | `install.sh` | `python3` | native (osascript) |
| Ubuntu / desktop Linux | `install.sh` | `python3` | `notify-send` |
| Linux server (headless) | `install.sh` | `python3` | logs to stderr |
| Windows (native) | `install.ps1` | `python` / `py` (auto-patched) | toast (BurntToast) or beep |
| Windows (WSL) | `install.sh` | `python3` | beep via `powershell.exe` |

If a Windows hook doesn't fire, confirm your Python command: `python --version`
or `py -3 --version`, then check the `command` lines in `~/.claude/settings.json`
point at that interpreter.

---

## What maps to which requirement

| Requirement | Where it lives |
|---|---|
| Free rein, stop at architecture only | `CLAUDE.md` autonomy contract + `plan-first` skill |
| Run on Mac/Windows/Ubuntu/servers | Python hooks + `install.sh`/`install.ps1` |
| Shareable with friends | neutral `CLAUDE.md` template + `CLAUDE.sabby.example.md` + `README.md` |
| Parallel sessions | worktree workflow + notify-done hook prints dir |
| Tests + reviewer + manual before done | `CLAUDE.md` verification bar + `/ship` + loop-runner exit |
| React+TS+Vite, Playwright, Claude Chrome | frontend rule + `.mcp.json` playwright + LSP plugin |
| Eval sets for LLM work | `llm-eval` skill (first-class) |
| Collaborators; no Co-Authored-By | `includeCoAuthoredBy:false` + git-discipline + collaboration rules |
| Ask+do on push; remote-first | permissions `ask` on push/PR/remote-add |
| Guardrails | permissions deny-list + `block_dangerous.py` hook |
| Opus preferred | `settings.json` model:opus |
| Looping | `loop-runner` skill + `/loop` |
| Karpathy process | `karpathy-guidelines` skill (default-on) |
| Layer-separated implement | `/implement` + logic-expert / ui-publisher / evaluator agents |
| Fast static gate | `check` skill + `/check` |
| Commit procedure | `git-flow` skill + `/commit` |
| Docs memory ledger | `memory-docs` skill + `/remember` + `docs/` templates |

---
---

# 한국어 설치 가이드

*아래는 위 영어 가이드의 한국어 번역입니다. 파일·명령어는 그대로 사용하세요.*

두 가지 산출물:
- **`globalclaude/`** → 전역 `~/.claude/`가 됩니다 (모든 프로젝트, 모든 IDE에 적용).
- **`project-template/`** → 각 저장소(repo) 루트에 내용을 복사합니다.

모든 것이 IDE·OS에 독립적입니다. 터미널, VS Code 확장, Cursor, Antigravity의
통합 터미널 중 무엇으로 Claude Code를 실행하든 — **macOS, Windows, Ubuntu,
Linux 서버** 어디서든 — 동일한 `~/.claude`와 저장소의 `.claude`를 읽으므로 모든
환경에서 동일하게 동작합니다.

> 훅(hook)과 상태 표시줄(status line)은 **Python 3**로 작성되어 있어(단일 소스)
> 모든 OS에서 실행됩니다. 이전 버전의 bash `.sh` 스크립트는 제거되었습니다.

---

## 사전 준비

- **Claude Code** 설치 및 로그인 완료 (`claude` CLI가 PATH에 있어야 함). 구독은
  Opus로 설정.
- **Python 3**가 PATH에 있어야 함 — 훅과 상태 표시줄에 필요. macOS/Linux는 보통
  `python3`, Windows는 `python` 또는 `py` 런처(Windows 설치 스크립트가 자동
  감지). Python이 없으면 훅은 그냥 건너뛰며 — 아무것도 깨지지 않고,
  `settings.json`의 deny 목록이 기본 방어선으로 남습니다.
- 선택: format-on-edit 훅용 `ruff`(Python), `prettier`(JS/TS); 상태 표시줄의
  브랜치 표시용 `git`. 포매터가 없으면 조용히 건너뜁니다.
- 참고: `globalclaude/`의 파일이 검증된 정본입니다.
  `agentic-coding-setup-blueprint.md` 안의 코드 조각은 설명용 예시입니다.

---

## 1단계 — 전역 레이어 설치

### 방법 A — 원커맨드 설치 스크립트 (권장)

**macOS / Linux / 서버**
```bash
cd "Sabby Agentic AI Setup"
./install.sh
```
**Windows (PowerShell)**
```powershell
cd "Sabby Agentic AI Setup"
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

설치 스크립트는 기존 `~/.claude`를 백업하고, `globalclaude/`를 복사하고, Python
훅에 실행 권한을 주고, Windows에서는 로컬 Python 명령에 맞게 `settings.json`을
수정합니다. 마지막으로 가드레일 훅을 스모크 테스트합니다.

### 방법 B — 수동 설치

```bash
cp -r globalclaude/. ~/.claude/
chmod +x ~/.claude/hooks/*.py     # 다운로드 시 실행 비트가 보존되지 않음
```

### 확인

```bash
ls ~/.claude                       # CLAUDE.md, settings.json, rules, skills, agents, hooks, commands
# 가드레일 스모크 테스트 (GUARDRAIL BLOCK 메시지와 exit=2가 나와야 정상):
printf '%s' '{"tool_input":{"command":"git push --force origin main"}}' \
  | python3 ~/.claude/hooks/block_dangerous.py; echo "exit=$?"
```

아무 저장소에서 Claude Code를 실행하고 `/help`, `/agents`, `/plugin`으로 로딩을
확인하세요. 상태 표시줄에 `dir ⎇ branch ⟨Opus⟩`가 보여야 합니다.

**내 것으로 만들기:** `~/.claude/CLAUDE.md`를 열어 `<<EDIT>>`로 표시된 부분만
수정하세요 (Who I am, Language, Stack defaults). 작성자의 실제 예시는 옆에 있는
`CLAUDE.sabby.example.md`입니다.

---

## 2단계 — 플러그인 설치

### 방법 A — 재현 가능한 스크립트

**macOS / Linux**
```bash
./plugins-install.sh
```
**Windows**
```powershell
powershell -ExecutionPolicy Bypass -File .\plugins-install.ps1
```

### 방법 B — Claude Code 안에서 (공식 마켓플레이스는 기본 등록됨)

```
/plugin install pyright-lsp@claude-plugins-official       # Python LSP  (바이너리: npm i -g pyright)
/plugin install typescript-lsp@claude-plugins-official    # TS/JS LSP   (바이너리: npm i -g typescript typescript-language-server)
/plugin install jdtls-lsp@claude-plugins-official         # Java LSP    (바이너리: brew install jdtls; JDK 17+)
/plugin install clangd-lsp@claude-plugins-official        # C/C++ LSP   (바이너리: LLVM의 clangd; compile_commands.json 필요)
/plugin install code-review@claude-plugins-official
/plugin install security-guidance@claude-plugins-official
/plugin install commit-commands@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install skill-creator@claude-plugins-official

/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace        # plan→spec→test 전체 워크플로우

/plugin marketplace add thedotmack/claude-mem              # 필수 — 3단계 참고
/plugin install claude-mem@thedotmack
```

**이것이 이 설정이 활성화한 정확한 목록입니다** (`settings.json`의
`enabledPlugins` 참고). 네 개의 LSP는 커넥터일 뿐이므로 — 언어 서버 **바이너리를
먼저** 설치한 뒤 플러그인, 그다음 `/reload-plugins`를 실행하세요. "X의 정의로
이동"으로 테스트: 즉시 `file:line` + 출력에 `LSP` 표시 = 정상 작동, grep 하고
있으면 = 연결 안 됨. `jdtls-lsp`는 JDK 17+와 `jdtls` 바이너리가, `clangd-lsp`는
`clangd`(LLVM)와 프로젝트의 `compile_commands.json`이 필요합니다.

다른 공식 LSP(같은 방식, 실제로 쓰는 언어만 설치): `gopls-lsp`,
`rust-analyzer-lsp`, `csharp-lsp`, `kotlin-lsp`, `swift-lsp`, `php-lsp`,
`ruby-lsp`. 대형 프로젝트에서 pyright/rust-analyzer/jdtls는 메모리를 많이 쓸 수
있으니 `/plugin disable <이름>`으로 되돌릴 수 있습니다.

Context7(최신 라이브러리 문서)와 Playwright(브라우저 검증)는 플러그인이 아니라
**프로젝트별** `.mcp.json`으로 연결합니다(4단계).

---

## 3단계 — Claude Mem (필수: 세션 간 메모리)

Claude Mem은 Claude Code에 세션 간 지속 메모리를 제공합니다 — 무슨 일이 있었는지
포착하고, 압축한 뒤, 관련 맥락을 이후 세션에 주입합니다. 설치하세요
(`plugins-install.sh` / `enabledPlugins`에 이미 포함):

```
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@thedotmack
```
그다음 Claude Code를 재시작하세요. (CLI 대체 설치: `npx claude-mem install`.
`npm i -g claude-mem`는 **쓰지 마세요** — SDK만 설치되고 플러그인 훅이 등록되지
않습니다.)

이 설정에서 두 가지 규칙:
- 지속적인 프로젝트 사실은 `CLAUDE.md`(단일 진실 공급원)에 두고, Claude Mem은
  부드러운 세션 간 맥락만 담게 하세요. "기억된" 사실이 `CLAUDE.md`와 충돌하면
  **`CLAUDE.md`가 우선**합니다.
- 병렬 세션에서는 메모리가 공유되므로, 한 프로젝트의 오래된 맥락이 다른
  프로젝트로 새지 않도록 가끔 정리하세요.

---

## 4단계 — 프로젝트 레이어 (각 저장소에서 수행)

```bash
cp -r "/경로/Sabby Agentic AI Setup/project-template/." .   # CLAUDE.md, .claude/, .mcp.json 복사
```
그다음:
1. `CLAUDE.md` 채우기 — 스택, 명령어, 레이아웃, 불변식(invariants), 함정, 그리고
   자주 하는 작업의 **성공 판정 명령**(loop-runner에 필요).
2. `.claude/rules/`의 경로 스코프 규칙을 저장소에 맞게 수정하거나, 해당 없는
   규칙은 삭제하세요. (기본 `frontend.md` 글롭은 의도적으로 프런트엔드 전용이니
   본인 레이아웃에 맞게 넓히세요.)
3. `.mcp.json`을 그 저장소가 실제로 쓰는 서버만 남기도록 정리하세요. GitHub MCP는
   원격(remote)을 설정한 뒤에만 추가하세요.
4. **협업자가 있는 저장소라면:** `CLAUDE.md`, `.claude/rules/`,
   `.claude/settings.json`, `.mcp.json`을 커밋하세요. `settings.local.json`과
   `.claude/loop/`는 gitignore로 제외(머신 로컬/임시).

권장 `.gitignore` 추가:
```
.claude/settings.local.json
.claude/loop/
```

팁: 매번 손으로 복사하는 대신, 새 저장소에서 Claude Code의 `/init`으로 `CLAUDE.md`
초안을 만든 뒤 템플릿의 불변식/함정을 그 위에 붙여넣으세요.

템플릿에는 `docs/Memory.md` + `docs/Index.md`(지속적 프로젝트 메모리 원장)도
포함됩니다. Memory.md는 추가 전용(append-only) 전체 항목(M-001, M-002, …)을,
Index.md는 항목별 1~2줄 요약과 정확한 줄 범위를 담습니다. `memory-docs` 스킬이
관리합니다: "remember this" 또는 `/remember <내용>`이라고 하면 Claude가 항목을
추가하고 인덱스 줄 범위를 다시 측정합니다(추정하지 않음). 두 파일 모두 커밋하세요
— 사람 협업자에게도 유용합니다.

---

## 4.5단계 — gstack plan-eng-review (필수)

계획 문서를 엔지니어 관점(아키텍처, 엣지 케이스, 테스트 커버리지)으로 검토해
`/plan`과 구현 사이에 끼워 넣는 도구입니다. 별도의 MIT 저장소(gstack, Garry Tan)
이고 자체 `bin/` 스크립트에 의존하므로 공식 설치 스크립트로 설치해야 합니다(파일
복사로는 동작하지 않음).

요구사항: Git, Bun v1.0+ (Windows는 Node.js도 필요). Claude Code에서:
```
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack \
  && cd ~/.claude/skills/gstack && ./setup
```
이후 `/plan-eng-review`가 계획을 검토합니다(`/review`, `/qa`, `/investigate`도
함께 설치). `/plan` 다음, 계획을 실행에 옮기기 전에 실행하세요.

---

## 5단계 — 일상 워크플로우 (더 루프)

자율성 계약, 검증 기준(verification bar), 루프 규율이 모두 연결돼 있습니다.
전형적인 비단순 작업 흐름:

1. `/plan <작업>` — plan-first 명세. 아키텍처 결정(새 서비스, 스키마 변경, 새
   의존성, 공개 계약)에서만 멈추고, 그 외에는 진행합니다.
2. *(선택)* `/plan-eng-review` — 계획의 엔지니어링 검토(gstack).
3. 구현:
   - **기본: 자유 재량.** 직접 구현하게 두세요(karpathy-guidelines가 변경을
     단순하고 외과적으로 유지). 소·중 규모 변경에 최적.
   - **큰 기능: `/implement <작업>`** — 전문 에이전트로 라우팅(architect →
     logic-expert / ui-publisher), `evaluator` 자가 점검 루프 포함, 로직과 UI를
     읽기 쉬운 별도 diff로 유지.
4. `/check` — 빠른 타입체크 + 린트 게이트. 저렴하고, 사소한 파손을 조기에 잡음.
5. `/loop <성공 기준>` — 판정 가능한 목표(테스트 통과, 타입 에러 제거, e2e 흐름
   그린)에. 기준 명령이 exit 0이 될 때까지 반복(폭주 방지 가드 포함).
6. `/ship` — 전체 검증 기준: check → test-runner → code-reviewer →
   (인증/데이터 변경 시 security-auditor). 수동 검토 준비 완료를 보고.
7. `/commit` — git-flow: 컨벤셔널 메시지, 승인 대기, Claude 표기 절대 없음, 릴리스
   경계에서 버전 범프 제안. `git push`/PR은 원격이 있은 뒤에만, 각각 승인 게이트를
   거치는 별도 단계입니다.

병렬 세션: `git worktree add ../repo-feature-x feature-x`로 각 Claude 세션이 자기
디렉터리/브랜치에서 작업하게 하세요. notify-done 훅이 어느 세션이 끝났는지
디렉터리 이름으로 알려줍니다.

---

## 6단계 — 건강하게 유지하기

Claude가 같은 실수를 두 번 하면, 수정을 레이어로 분류하세요:
- **사실** 누락 → `CLAUDE.md`에 추가(200줄 미만 유지).
- **절차** 누락 → 새/갱신 **스킬**.
- **제약** 누락 → **규칙**(경로 스코프) 또는 **훅**(결정적이어야 한다면).
- **위임**했어야 함 → 새/조정 **서브에이전트**.

분기마다 정리하세요. 항상 로드되는 문맥의 모든 줄이 나머지를 희석합니다. 안정되면
`skills/ agents/ hooks/ commands/`를 개인 **플러그인**으로 묶어 버전 관리하고
머신 간 이식성을 확보하세요.

---

## 크로스 플랫폼 참고표

| OS | 설치 | 훅 인터프리터 | 알림 |
|---|---|---|---|
| macOS | `install.sh` | `python3` | 네이티브(osascript) |
| Ubuntu / 데스크톱 Linux | `install.sh` | `python3` | `notify-send` |
| Linux 서버(헤드리스) | `install.sh` | `python3` | stderr 로그 |
| Windows(네이티브) | `install.ps1` | `python` / `py` (자동 패치) | 토스트(BurntToast) 또는 비프 |
| Windows(WSL) | `install.sh` | `python3` | `powershell.exe` 비프 |

Windows에서 훅이 동작하지 않으면 Python 명령을 확인하세요: `python --version`
또는 `py -3 --version`. 그다음 `~/.claude/settings.json`의 `command` 줄이 그
인터프리터를 가리키는지 확인하세요.
