# michaelmux Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a `michaelmux` CLI that creates/finds a git worktree for a given branch or GitHub PR, opens or focuses its kitty tab, and switches aerospace to workspace 2.

**Architecture:** Single bash CLI dispatcher under `~/dotfiles/michaelmux/bin/michaelmux` that sources subcommand scripts from `lib/`. Stateless — sources of truth are `git worktree list --porcelain` and `kitty @ ls`.

**Tech Stack:** bash 5, `jq`, `gh`, `git`, `kitty @` remote control, `aerospace` CLI.

**Testing:** No automated tests. This is a personal dev tool; each task ends in a manual smoke test.

**Spec:** `docs/superpowers/specs/2026-05-13-michaelmux-design.md`

---

## File map

| File | Responsibility |
|------|----------------|
| `~/dotfiles/michaelmux/bin/michaelmux` | Dispatcher: parse subcommand, source `lib/common.sh`, dispatch to `cmd_*.sh` |
| `~/dotfiles/michaelmux/lib/common.sh` | `require_deps`, `repo_root`, `kitty_tab_for_cwd`, `aerospace_focus_workspace`, logging |
| `~/dotfiles/michaelmux/lib/resolve.sh` | `resolve_input <repo_root> <input>` → prints `kind\tbranch\tworktree_path` |
| `~/dotfiles/michaelmux/lib/cmd_open.sh` | `cmd_open <input>` — resolve, ensure worktree, open/focus tab, focus workspace |
| `~/dotfiles/michaelmux/lib/cmd_list.sh` | `cmd_list` — walk worktrees, render columns |
| `~/dotfiles/michaelmux/lib/cmd_goto.sh` | `cmd_goto <name>` — fuzzy match, focus or open |
| `~/dotfiles/michaelmux/README.md` | Install, PATH, kitty `listen_on` requirement |
| `~/.claude/skills/michaelmux/SKILL.md` | Tells Claude when to call `michaelmux` |

---

### Task 1: Scaffold directory and dispatcher

**Files:**
- Create: `~/dotfiles/michaelmux/bin/michaelmux`
- Create: `~/dotfiles/michaelmux/lib/common.sh` (stub)
- Create: `~/dotfiles/michaelmux/lib/resolve.sh` (stub)
- Create: `~/dotfiles/michaelmux/lib/cmd_open.sh` (stub)
- Create: `~/dotfiles/michaelmux/lib/cmd_list.sh` (stub)
- Create: `~/dotfiles/michaelmux/lib/cmd_goto.sh` (stub)

- [ ] **Step 1: Create the directory layout**

```bash
mkdir -p ~/dotfiles/michaelmux/{bin,lib}
```

- [ ] **Step 2: Write the dispatcher**

Create `~/dotfiles/michaelmux/bin/michaelmux`:
```bash
#!/usr/bin/env bash
set -euo pipefail

MICHAELMUX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/common.sh
source "$MICHAELMUX_ROOT/lib/common.sh"

usage() {
    cat <<EOF
Usage: michaelmux <command> [args]

Commands:
  open <branch-or-pr>   Create/find worktree, open or focus kitty tab.
  list                  Show worktrees with tab + PR status.
  goto <name>           Focus or open the tab for a worktree.
EOF
}

cmd="${1:-}"; shift || true
case "$cmd" in
    open)  source "$MICHAELMUX_ROOT/lib/cmd_open.sh";  cmd_open  "$@" ;;
    list)  source "$MICHAELMUX_ROOT/lib/cmd_list.sh";  cmd_list  "$@" ;;
    goto)  source "$MICHAELMUX_ROOT/lib/cmd_goto.sh";  cmd_goto  "$@" ;;
    -h|--help|help|"") usage ;;
    *) echo "unknown command: $cmd" >&2; usage >&2; exit 1 ;;
esac
```

- [ ] **Step 3: Write stub lib files**

Create each of the following with `# shellcheck shell=bash` as the only line, except the cmd files which also need a stub function so the dispatcher can call them.

`lib/common.sh`:
```bash
# shellcheck shell=bash
```

`lib/resolve.sh`:
```bash
# shellcheck shell=bash
```

`lib/cmd_open.sh`:
```bash
# shellcheck shell=bash
cmd_open() { echo "cmd_open not yet implemented" >&2; exit 1; }
```

`lib/cmd_list.sh`:
```bash
# shellcheck shell=bash
cmd_list() { echo "cmd_list not yet implemented" >&2; exit 1; }
```

`lib/cmd_goto.sh`:
```bash
# shellcheck shell=bash
cmd_goto() { echo "cmd_goto not yet implemented" >&2; exit 1; }
```

- [ ] **Step 4: Make the dispatcher executable and smoke test**

```bash
chmod +x ~/dotfiles/michaelmux/bin/michaelmux
~/dotfiles/michaelmux/bin/michaelmux help
```
Expected: usage block prints, exit 0.

- [ ] **Step 5: Commit**

```bash
cd ~/dotfiles
git add michaelmux
git commit -m "michaelmux: scaffold dispatcher and lib stubs"
```

---

### Task 2: `common.sh` — deps, repo root, kitty/aerospace helpers

**Files:**
- Modify: `~/dotfiles/michaelmux/lib/common.sh`

- [ ] **Step 1: Implement `common.sh`**

Replace `lib/common.sh` contents:
```bash
# shellcheck shell=bash

log()  { printf '%s\n' "$*" >&2; }
die()  { local code="$1"; shift; log "michaelmux: $*"; exit "$code"; }

require_deps() {
    local missing=()
    for dep in git jq gh kitty aerospace; do
        command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
    done
    if (( ${#missing[@]} )); then
        die 2 "missing dependencies: ${missing[*]}"
    fi
    if ! kitty @ ls >/dev/null 2>&1; then
        die 2 "kitty @ ls failed — add \`listen_on unix:/tmp/kitty-\$USER\` to kitty.conf and restart kitty"
    fi
}

repo_root() {
    local root
    if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
        printf '%s\n' "$root"
        return
    fi
    if [[ -n "${MICHAELMUX_DEFAULT_REPO:-}" && -d "$MICHAELMUX_DEFAULT_REPO" ]]; then
        printf '%s\n' "$MICHAELMUX_DEFAULT_REPO"
        return
    fi
    die 2 "not in a git repo and MICHAELMUX_DEFAULT_REPO is unset"
}

# Print the first kitty tab id whose any window has cwd == $1, or empty.
kitty_tab_for_cwd() {
    local cwd="$1"
    kitty @ ls 2>/dev/null \
        | jq -r --arg cwd "$cwd" '
            .[] | .tabs[] | select(.windows[]?.cwd == $cwd) | .id
        ' \
        | head -1
}

aerospace_focus_workspace() {
    local ws="${MICHAELMUX_WORKSPACE:-2}"
    aerospace workspace "$ws" >/dev/null 2>&1 || log "aerospace workspace $ws failed"
}
```

- [ ] **Step 2: Smoke test**

```bash
bash -n ~/dotfiles/michaelmux/lib/common.sh
~/dotfiles/michaelmux/bin/michaelmux help
```
Expected: no syntax errors; usage still prints.

- [ ] **Step 3: Commit**

```bash
cd ~/dotfiles
git add michaelmux
git commit -m "michaelmux: common.sh deps + kitty/aerospace helpers"
```

---

### Task 3: `resolve.sh` — branch and PR URL input

**Files:**
- Modify: `~/dotfiles/michaelmux/lib/resolve.sh`

- [ ] **Step 1: Implement `resolve_input`**

Replace `lib/resolve.sh` contents:
```bash
# shellcheck shell=bash

# resolve_input <repo_root> <input>
# Prints: <kind>\t<branch>\t<worktree_path>
# kind: "branch" | "review"
resolve_input() {
    local repo_root="$1"
    local input="$2"

    if [[ "$input" =~ ^https?://github\.com/[^/]+/[^/]+/pull/[0-9]+ ]] \
        || [[ "$input" =~ ^[^/]+/[^/]+#[0-9]+$ ]]; then
        _resolve_pr "$repo_root" "$input"
        return
    fi

    printf 'branch\t%s\t%s\n' "$input" "$repo_root/.worktrees/$input"
}

_resolve_pr() {
    local repo_root="$1"
    local input="$2"

    local json
    json="$(gh pr view "$input" --json headRefName,author,isCrossRepository 2>/dev/null)" \
        || { echo "michaelmux: gh pr view failed for: $input" >&2; return 1; }

    local cross_fork branch author
    cross_fork="$(jq -r '.isCrossRepository' <<<"$json")"
    branch="$(jq -r '.headRefName' <<<"$json")"
    author="$(jq -r '.author.login' <<<"$json")"

    if [[ "$cross_fork" == "true" ]]; then
        echo "michaelmux: cross-fork PRs not supported in v1" >&2
        return 1
    fi

    printf 'review\t%s\t%s\n' "$branch" "$repo_root/.worktrees/reviews/$author/$branch"
}
```

- [ ] **Step 2: Smoke test — branch input**

```bash
bash -c 'source ~/dotfiles/michaelmux/lib/resolve.sh && resolve_input /tmp/fake michael/dbtypes_factory'
```
Expected:
```
branch	michael/dbtypes_factory	/tmp/fake/.worktrees/michael/dbtypes_factory
```

- [ ] **Step 3: Smoke test — real same-repo PR**

Pick a recent same-repo PR URL (e.g. from `gh pr list -R torch-dental/torchweb -L 1 --json url -q '.[0].url'`):
```bash
bash -c 'source ~/dotfiles/michaelmux/lib/resolve.sh && resolve_input /tmp/fake <pr-url>'
```
Expected: tab-separated line starting with `review`, the PR's head ref, and a `/tmp/fake/.worktrees/reviews/<author>/<branch>` path.

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles
git add michaelmux
git commit -m "michaelmux: resolve branch and PR URL inputs"
```

---

### Task 4: `cmd_open` — worktree + tab + workspace

**Files:**
- Modify: `~/dotfiles/michaelmux/lib/cmd_open.sh`

- [ ] **Step 1: Implement `cmd_open`**

Replace `lib/cmd_open.sh` contents:
```bash
# shellcheck shell=bash
# shellcheck source=resolve.sh
source "$MICHAELMUX_ROOT/lib/resolve.sh"

cmd_open() {
    local input="${1:-}"
    [[ -z "$input" ]] && die 1 "usage: michaelmux open <branch-or-pr>"

    require_deps
    local root; root="$(repo_root)"

    local resolved kind branch wt
    resolved="$(resolve_input "$root" "$input")" || exit $?
    IFS=$'\t' read -r kind branch wt <<<"$resolved"

    wt="$(_ensure_worktree "$root" "$branch" "$wt")" || exit $?

    _open_or_focus_tab "$wt"
    aerospace_focus_workspace
    log "michaelmux: $wt"
}

# Ensures the worktree exists. Prints the worktree path on success
# (which may differ from the requested path if the branch was already
# checked out elsewhere).
_ensure_worktree() {
    local root="$1" branch="$2" wt="$3"

    if [[ -d "$wt" ]]; then
        printf '%s\n' "$wt"
        return 0
    fi

    if ! git -C "$root" rev-parse --verify "$branch" >/dev/null 2>&1; then
        if git -C "$root" ls-remote --exit-code origin "$branch" >/dev/null 2>&1; then
            git -C "$root" fetch origin "$branch:$branch" >/dev/null
        else
            die 1 "branch '$branch' not found locally or on origin"
        fi
    fi

    local err
    err="$(mktemp)"
    if git -C "$root" worktree add "$wt" "$branch" 2>"$err"; then
        rm -f "$err"
        printf '%s\n' "$wt"
        return 0
    fi

    local existing
    existing="$(git -C "$root" worktree list --porcelain \
        | awk -v b="refs/heads/$branch" '
            /^worktree / { p=$2 }
            $0 == "branch " b { print p }
        ' | head -1)"
    if [[ -n "$existing" ]]; then
        log "michaelmux: branch already checked out at $existing; using that"
        rm -f "$err"
        printf '%s\n' "$existing"
        return 0
    fi

    cat "$err" >&2
    rm -f "$err"
    return 1
}

_open_or_focus_tab() {
    local wt="$1"
    local tab_id; tab_id="$(kitty_tab_for_cwd "$wt")"
    if [[ -n "$tab_id" ]]; then
        kitty @ focus-tab --match "id:$tab_id"
    else
        kitty @ launch --type=tab \
            --tab-title "$(basename "$wt")" \
            --cwd "$wt" >/dev/null
    fi
}
```

- [ ] **Step 2: Smoke test — new branch (creates worktree + tab)**

From inside `~/src/torchweb`, pick a branch without an existing worktree (replace `<branch>` below):
```bash
~/dotfiles/michaelmux/bin/michaelmux open <branch>
```
Expected:
- Directory `~/src/torchweb/.worktrees/<branch>` exists.
- A new kitty tab opens, titled with `basename "<branch>"`, cwd = the worktree.
- Aerospace is now on workspace 2.

- [ ] **Step 3: Smoke test — re-open focuses existing tab**

Switch to a different kitty tab, then rerun the same command:
```bash
~/dotfiles/michaelmux/bin/michaelmux open <branch>
```
Expected: kitty focuses the existing tab; no new tab is created.

- [ ] **Step 4: Smoke test — PR URL**

```bash
~/dotfiles/michaelmux/bin/michaelmux open <pr-url-from-same-repo>
```
Expected: worktree at `.worktrees/reviews/<author>/<branch>` exists; tab focused.

- [ ] **Step 5: Cleanup any test worktrees you don't want to keep**

```bash
git -C ~/src/torchweb worktree remove ~/src/torchweb/.worktrees/<branch>
```

- [ ] **Step 6: Commit**

```bash
cd ~/dotfiles
git add michaelmux
git commit -m "michaelmux: cmd_open creates worktree, opens tab, focuses workspace"
```

---

### Task 5: `cmd_list`

**Files:**
- Modify: `~/dotfiles/michaelmux/lib/cmd_list.sh`

- [ ] **Step 1: Implement `cmd_list`**

Replace `lib/cmd_list.sh` contents:
```bash
# shellcheck shell=bash

cmd_list() {
    require_deps
    local root; root="$(repo_root)"

    local kitty_json
    kitty_json="$(kitty @ ls 2>/dev/null || echo '[]')"

    printf '%-60s %-50s %-4s %s\n' "PATH" "BRANCH" "TAB" "PR"
    git -C "$root" worktree list --porcelain | awk '
        /^worktree / { p=$2; next }
        /^branch / { sub("refs/heads/", "", $2); print p"\t"$2 }
    ' | while IFS=$'\t' read -r path branch; do
        local rel="${path#"$root"/}"
        local tab_mark; tab_mark="$(_tab_marker "$kitty_json" "$path")"
        local pr_url; pr_url="$(_pr_url_for_branch "$branch")"
        printf '%-60s %-50s %-4s %s\n' "$rel" "$branch" "$tab_mark" "$pr_url"
    done
}

_tab_marker() {
    local kitty_json="$1" cwd="$2"
    local id
    id="$(jq -r --arg cwd "$cwd" '
        .[] | .tabs[] | select(.windows[]?.cwd == $cwd) | .id
    ' <<<"$kitty_json" | head -1)"
    [[ -n "$id" ]] && printf '●' || printf '○'
}

_pr_url_for_branch() {
    local branch="$1"
    timeout 3 gh pr list --head "$branch" --json url --limit 1 2>/dev/null \
        | jq -r '.[0].url // empty'
}
```

- [ ] **Step 2: Smoke test**

From inside `~/src/torchweb`:
```bash
~/dotfiles/michaelmux/bin/michaelmux list
```
Expected: column-aligned list with one row per worktree. Rows for worktrees currently open in kitty tabs show `●`; others show `○`. PR column shows URLs where a matching open PR exists.

- [ ] **Step 3: Commit**

```bash
cd ~/dotfiles
git add michaelmux
git commit -m "michaelmux: cmd_list with tab + PR columns"
```

---

### Task 6: `cmd_goto`

**Files:**
- Modify: `~/dotfiles/michaelmux/lib/cmd_goto.sh`

- [ ] **Step 1: Implement `cmd_goto`**

Replace `lib/cmd_goto.sh` contents:
```bash
# shellcheck shell=bash

cmd_goto() {
    local name="${1:-}"
    [[ -z "$name" ]] && die 1 "usage: michaelmux goto <name>"

    require_deps
    local root; root="$(repo_root)"

    mapfile -t paths < <(git -C "$root" worktree list --porcelain \
        | awk '/^worktree / { print $2 }')

    local matches=()
    for p in "${paths[@]}"; do
        if [[ "$p" == "$name" || "$(basename "$p")" == "$name" || "$p" == *"$name" ]]; then
            matches+=("$p")
        fi
    done

    if (( ${#matches[@]} == 0 )); then
        log "no worktree matches '$name'. candidates:"
        printf '  %s\n' "${paths[@]}" >&2
        exit 1
    fi
    if (( ${#matches[@]} > 1 )); then
        log "ambiguous: '$name' matches:"
        printf '  %s\n' "${matches[@]}" >&2
        exit 1
    fi

    local wt="${matches[0]}"
    local tab_id; tab_id="$(kitty_tab_for_cwd "$wt")"
    if [[ -n "$tab_id" ]]; then
        kitty @ focus-tab --match "id:$tab_id"
    else
        kitty @ launch --type=tab \
            --tab-title "$(basename "$wt")" \
            --cwd "$wt" >/dev/null
    fi
    aerospace_focus_workspace
}
```

- [ ] **Step 2: Smoke test — basename match**

Pick an existing worktree (replace `<basename>` below — e.g. `dbtypes_factory`):
```bash
~/dotfiles/michaelmux/bin/michaelmux goto <basename>
```
Expected: kitty tab for that worktree is focused (or opened if none); aerospace on workspace 2.

- [ ] **Step 3: Smoke test — no match**

```bash
~/dotfiles/michaelmux/bin/michaelmux goto nonsense
```
Expected: exit 1 with "no worktree matches 'nonsense'. candidates:" followed by the path list.

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles
git add michaelmux
git commit -m "michaelmux: cmd_goto with fuzzy suffix match"
```

---

### Task 7: Skill file and README

**Files:**
- Create: `~/.claude/skills/michaelmux/SKILL.md`
- Create: `~/dotfiles/michaelmux/README.md`

- [ ] **Step 1: Write the skill**

```bash
mkdir -p ~/.claude/skills/michaelmux
```

Create `~/.claude/skills/michaelmux/SKILL.md`:
```markdown
---
name: michaelmux
description: Use when the user asks to open, check out, review, or switch to a branch or GitHub PR on this machine. Invoke `michaelmux open <input>` instead of running `git worktree add` and `kitty @ launch` by hand. Also covers listing or switching between active worktrees via `michaelmux list` / `michaelmux goto`.
---

# michaelmux

`michaelmux` manages the kitty-tab + git-worktree pair for each branch or PR Michael is working on. It is the preferred way to open new work on this machine.

## When to use

- "Open `<branch>`" / "check out `<branch>`" / "switch to `<branch>`" → `michaelmux open <branch>`
- "Review `<github-pr-url>`" / "look at this PR" → `michaelmux open <pr-url>`
- "What worktrees do I have / which are open in tabs?" → `michaelmux list`
- "Jump back to the `<name>` worktree" → `michaelmux goto <name>`

## Behavior

- Creates the worktree under `<repo>/.worktrees/<branch>` for branches, or `<repo>/.worktrees/reviews/<author>/<branch>` for PR URLs.
- Branch name is preserved as-is (no stripping of `michael/`).
- Opens a new kitty tab pointed at the worktree, or focuses the existing tab if one is already there. Then switches aerospace to workspace 2.
- Exit codes: `0` ok, `1` user error, `2` environment error.

## Fallback

If `michaelmux` exits with `2`, surface the error to Michael and fall back to manual `git worktree add` / `kitty @ launch` commands. Don't silently work around it.
```

- [ ] **Step 2: Write the README**

Create `~/dotfiles/michaelmux/README.md`:
```markdown
# michaelmux

CLI for managing the kitty tab + git worktree for each branch or PR.

## Install

Symlink the dispatcher into your PATH. Example:

    ln -s ~/dotfiles/michaelmux/bin/michaelmux ~/.local/bin/michaelmux

## Requirements

- `git`, `jq`, `gh`, `kitty`, `aerospace` on PATH
- `kitty.conf` must contain both:

      allow_remote_control yes
      listen_on unix:/tmp/kitty-$USER

  Restart kitty after adding `listen_on`.

## Commands

    michaelmux open <branch>          # or a GitHub PR URL
    michaelmux list
    michaelmux goto <name>

## Environment

- `MICHAELMUX_WORKSPACE` — aerospace workspace to focus (default `2`)
- `MICHAELMUX_DEFAULT_REPO` — fallback repo root when not run inside a git repo
- `MICHAELMUX_DEBUG=1` — verbose output (set `-x` in scripts)
```

- [ ] **Step 3: Final smoke test**

```bash
~/dotfiles/michaelmux/bin/michaelmux help
~/dotfiles/michaelmux/bin/michaelmux list
```
Expected: usage prints; list renders.

- [ ] **Step 4: Commit**

```bash
cd ~/dotfiles
git add michaelmux/README.md
git commit -m "michaelmux: README and install notes"
```

The skill at `~/.claude/skills/michaelmux/SKILL.md` only needs committing if that path is under a git-tracked location for you.

---

## Self-review notes

- **Spec coverage:**
  - CLI surface (`open`, `list`, `goto`) → Tasks 1, 4, 5, 6
  - Branch input → Task 3
  - PR URL input (same-repo) → Task 3
  - Cross-fork PR rejection → Task 3
  - Repo root detection + deps → Task 2
  - Worktree creation incl. "already checked out elsewhere" → Task 4
  - Kitty tab open/focus → Task 4
  - Aerospace workspace switch → Task 4
  - `list` columns incl. PR best-effort → Task 5
  - `goto` with fuzzy match → Task 6
  - Skill markdown → Task 7
  - kitty `listen_on` requirement called out → Task 2 (`require_deps`) + Task 7 (README)
  - Exit codes → encoded via `die 1 ...` / `die 2 ...`
  - `MICHAELMUX_*` env vars → Task 2 + Task 7 (README docs)
- **Out-of-scope items** (TODO linking, `close`, fork PR support, per-project workspaces) are correctly absent.
