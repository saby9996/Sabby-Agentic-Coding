# Sabby's Agentic AI Coding Setup

A portable, opinionated Claude Code environment — the same "brain" on **macOS,
Windows, Ubuntu, and Linux servers**, in any editor (terminal, VS Code, Cursor,
Antigravity). Clone it, run one installer, and Claude Code behaves consistently
everywhere: guardrails, verification bar, specialist subagents, and workflow
skills all pre-wired.

> New here (a friend Sabby shared this with)? Read this file, then
> **[INSTALL-GUIDE.md](INSTALL-GUIDE.md)**. You only edit a few clearly-marked
> spots to make it yours.

---

## What's in the box

| Path | What it is |
|---|---|
| `globalclaude/` | Becomes your global `~/.claude/` — applies to **every** project. |
| `globalclaude/CLAUDE.md` | Your cross-project operating manual (edit the `<<EDIT>>` blocks). |
| `globalclaude/CLAUDE.sabby.example.md` | The author's real, filled-in version — a worked example to copy from. |
| `globalclaude/settings.json` | Model, permissions (allow/ask/deny), hooks, status line, enabled plugins. |
| `globalclaude/hooks/*.py` | Cross-platform Python hooks: guardrail, auto-format, notify, status line. |
| `globalclaude/rules/` `skills/` `agents/` `commands/` | The reusable framework — 3 rules, 11 skills, 9 subagents, 8 slash commands. |
| `project-template/` | Copy into each repo: project `CLAUDE.md`, path rules, `.mcp.json`, memory ledger. |
| `install.sh` / `install.ps1` | One-command install of `globalclaude/` → `~/.claude/`. |
| `plugins-install.sh` / `.ps1` | Reproducible install of all 11 plugins + the 2 community marketplaces. |
| `INSTALL-GUIDE.md` | Full setup + daily workflow, in **English and 한국어**. |
| `agentic-coding-setup-blueprint.md` | The "why" — the mental model and design rationale. |

---

## Quick start

**macOS / Linux / servers**
```bash
cd "Sabby Agentic AI Setup"
./install.sh            # copies globalclaude/ -> ~/.claude, makes hooks executable
./plugins-install.sh    # installs all 11 plugins (needs the `claude` CLI)
```

**Windows (PowerShell)**
```powershell
cd "Sabby Agentic AI Setup"
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\plugins-install.ps1
```

Then open Claude Code in any repo and run `/help`, `/agents`, `/plugin` to
confirm it loaded. Your status line should read `dir ⎇ branch ⟨Opus⟩`.

**Make it yours (2 minutes):** open `~/.claude/CLAUDE.md` and edit the sections
marked `<<EDIT>>` (who you are, your languages, your default stack). Everything
else is the framework — leave it.

---

## Requirements

- **Claude Code** installed and signed in (the `claude` CLI on your PATH).
- **Python 3** on PATH — the hooks and status line are Python (works on all
  OSes). Missing Python just means hooks are skipped; nothing breaks.
- **Required companions** (installed by `plugins-install` / Step 3–4.5):
  **Claude Mem** (`claude-mem@thedotmack`, cross-session memory) and **gstack
  plan-eng-review** (Git + Bun v1.0+; Windows also needs Node.js).
- LSP binaries for the languages you use: `pyright` (Python),
  `typescript-language-server` (TS/JS), `jdtls` + JDK 17+ (Java), `clangd` from
  LLVM (C/C++, needs `compile_commands.json`).
- Optional but recommended: `ruff` (Python format), `prettier` (JS/TS format)
  for the auto-format hook; `git` for the status line branch display.

### Cross-platform notes

| OS | Hooks | Notifications | Install |
|---|---|---|---|
| macOS | Python ✓ | native (osascript) | `install.sh` |
| Ubuntu / desktop Linux | Python ✓ | `notify-send` | `install.sh` |
| Linux servers (headless) | Python ✓ | logs to stderr | `install.sh` |
| Windows (native) | Python ✓ | toast (BurntToast) or beep | `install.ps1` |
| Windows (WSL) | Python ✓ | beep via `powershell.exe` | `install.sh` |

The Windows installer auto-detects `python` / `py` and patches `settings.json`
accordingly, since Windows often doesn't ship a `python3` alias.

---

## Sharing this with friends

1. Zip the whole `Sabby Agentic AI Setup/` folder (or push it to a git repo) and
   send it.
2. They run the installer for their OS, then `plugins-install`.
3. They edit the `<<EDIT>>` blocks in `~/.claude/CLAUDE.md`.

The framework parts (autonomy contract, verification bar, guardrail hook, slash
commands) are designed to be used as-is. The only personal bits are the marked
identity/stack/language sections. Nothing here contains secrets — `.env` reads
are actively denied by the permission rules and the guardrail hook.

---

## Keeping it healthy

When Claude gets something wrong twice, classify the fix by layer (see the
blueprint): missing **fact** → `CLAUDE.md`; missing **procedure** → a **skill**;
missing **constraint** → a **rule** or **hook**; should've been **delegated** →
a **subagent**. Prune quarterly — every always-loaded line dilutes the rest.

---
---

# Sabby의 에이전틱 AI 코딩 설정 (한국어)

**macOS, Windows, Ubuntu, Linux 서버** 어디서나 동일한 "두뇌"를 제공하는, 이식성
높고 의견이 뚜렷한 Claude Code 환경입니다. 어떤 에디터(터미널, VS Code, Cursor,
Antigravity)에서도 동일하게 동작합니다. 클론하고 설치 스크립트 하나만 실행하면
가드레일, 검증 기준(verification bar), 전문 서브에이전트, 워크플로우 스킬이 모두
미리 연결된 상태로 일관되게 작동합니다.

> 처음 오셨나요(Sabby가 공유해 준 친구)? 이 파일을 먼저 읽고
> **[INSTALL-GUIDE.md](INSTALL-GUIDE.md)**로 이동하세요. 명확히 표시된 몇 군데만
> 수정하면 자기 것으로 만들 수 있습니다.

## 구성 (What's in the box)

| 경로 | 설명 |
|---|---|
| `globalclaude/` | 전역 `~/.claude/`가 됩니다 — **모든** 프로젝트에 적용. |
| `globalclaude/CLAUDE.md` | 프로젝트 공통 운영 매뉴얼 (`<<EDIT>>` 블록만 수정). |
| `globalclaude/CLAUDE.sabby.example.md` | 작성자의 실제 작성본 — 참고용 예시. |
| `globalclaude/settings.json` | 모델, 권한(allow/ask/deny), 훅, 상태 표시줄, 활성 플러그인. |
| `globalclaude/hooks/*.py` | 크로스 플랫폼 Python 훅: 가드레일, 자동 포맷, 알림, 상태 표시줄. |
| `globalclaude/rules/` `skills/` `agents/` `commands/` | 재사용 프레임워크 — 규칙 3, 스킬 11, 서브에이전트 9, 슬래시 명령 8. |
| `project-template/` | 각 저장소에 복사: 프로젝트 `CLAUDE.md`, 경로 규칙, `.mcp.json`, 메모리 원장. |
| `install.sh` / `install.ps1` | `globalclaude/` → `~/.claude/` 원커맨드 설치. |
| `plugins-install.sh` / `.ps1` | 11개 플러그인 + 2개 커뮤니티 마켓플레이스 재현 설치. |
| `INSTALL-GUIDE.md` | 전체 설치 + 일상 워크플로우 (**영어 및 한국어**). |
| `agentic-coding-setup-blueprint.md` | "왜" — 멘탈 모델과 설계 근거. |

## 빠른 시작

**macOS / Linux / 서버**
```bash
cd "Sabby Agentic AI Setup"
./install.sh            # globalclaude/ -> ~/.claude 복사, 훅 실행권한 부여
./plugins-install.sh    # 11개 플러그인 설치 (`claude` CLI 필요)
```

**Windows (PowerShell)**
```powershell
cd "Sabby Agentic AI Setup"
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\plugins-install.ps1
```

그다음 아무 저장소에서 Claude Code를 열고 `/help`, `/agents`, `/plugin`으로 로딩을
확인하세요. 상태 표시줄에 `dir ⎇ branch ⟨Opus⟩`가 보여야 합니다.

**내 것으로 만들기(2분):** `~/.claude/CLAUDE.md`를 열어 `<<EDIT>>`로 표시된
부분(나는 누구인가, 사용 언어, 기본 스택)만 수정하세요. 나머지는 프레임워크이니
그대로 두세요.

## 요구사항

- **Claude Code** 설치 및 로그인 (`claude` CLI가 PATH에 있어야 함).
- **Python 3**가 PATH에 있어야 함 — 훅과 상태 표시줄이 Python(모든 OS 지원).
  Python이 없으면 훅만 건너뛰며 아무것도 깨지지 않습니다.
- **필수 동반 도구**(`plugins-install` / 3~4.5단계로 설치): **Claude Mem**
  (`claude-mem@thedotmack`, 세션 간 메모리)과 **gstack plan-eng-review**
  (Git + Bun v1.0+; Windows는 Node.js도 필요).
- 사용하는 언어의 LSP 바이너리: `pyright`(Python),
  `typescript-language-server`(TS/JS), `jdtls` + JDK 17+(Java),
  LLVM의 `clangd`(C/C++, `compile_commands.json` 필요).
- 선택(권장): 자동 포맷 훅용 `ruff`(Python), `prettier`(JS/TS); 상태 표시줄
  브랜치 표시용 `git`.

### 크로스 플랫폼 참고

| OS | 훅 | 알림 | 설치 |
|---|---|---|---|
| macOS | Python ✓ | 네이티브(osascript) | `install.sh` |
| Ubuntu / 데스크톱 Linux | Python ✓ | `notify-send` | `install.sh` |
| Linux 서버(헤드리스) | Python ✓ | stderr 로그 | `install.sh` |
| Windows(네이티브) | Python ✓ | 토스트(BurntToast) 또는 비프 | `install.ps1` |
| Windows(WSL) | Python ✓ | `powershell.exe` 비프 | `install.sh` |

Windows 설치 스크립트는 `python` / `py`를 자동 감지해 `settings.json`을
수정합니다(Windows에는 `python3` 별칭이 없는 경우가 많기 때문).

## 친구에게 공유하기

1. `Sabby Agentic AI Setup/` 폴더 전체를 압축하거나 git 저장소에 푸시해 전달.
2. 친구는 자기 OS용 설치 스크립트를 실행한 뒤 `plugins-install` 실행.
3. `~/.claude/CLAUDE.md`의 `<<EDIT>>` 블록을 수정.

프레임워크 부분(자율성 계약, 검증 기준, 가드레일 훅, 슬래시 명령)은 그대로 쓰도록
설계되었습니다. 개인 부분은 표시된 정체성/스택/언어 섹션뿐입니다. 이 패키지에는
비밀정보가 없습니다 — `.env` 읽기는 권한 규칙과 가드레일 훅으로 능동적으로
차단됩니다.

## 건강하게 유지하기

Claude가 같은 실수를 두 번 하면 수정을 레이어로 분류하세요(블루프린트 참고):
**사실** 누락 → `CLAUDE.md`; **절차** 누락 → **스킬**; **제약** 누락 → **규칙**
또는 **훅**; **위임**했어야 함 → **서브에이전트**. 분기마다 정리하세요 — 항상
로드되는 모든 줄이 나머지를 희석합니다.
