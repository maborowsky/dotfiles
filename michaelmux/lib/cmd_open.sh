# shellcheck shell=bash
# shellcheck source=resolve.sh
source "$MICHAELMUX_ROOT/lib/resolve.sh"

cmd_open() {
    local create=0 base="" use_zmx="${MICHAELMUX_USE_ZMX:-0}" input=""
    while (( $# )); do
        case "$1" in
            -c|--create) create=1; shift ;;
            -z|--zmx) use_zmx=1; shift ;;
            --no-zmx) use_zmx=0; shift ;;
            --base) base="${2:-}"; shift 2 ;;
            --base=*) base="${1#--base=}"; shift ;;
            -h|--help) cat <<EOF; return 0
usage: michaelmux open [-c|--create] [-z|--zmx] [--base <ref>] <branch-or-pr>

  -c, --create   Create the branch from the default base if it doesn't exist.
  -z, --zmx      Run the tab inside a zmx session named after the tab title.
                 (Implicit when MICHAELMUX_USE_ZMX=1; override with --no-zmx.)
  --base <ref>   Override the base used with --create (default: origin/HEAD).
EOF
                ;;
            --) shift; input="${1:-}"; break ;;
            -*) die 1 "unknown flag: $1" ;;
            *)  input="$1"; shift ;;
        esac
    done

    [[ -z "$input" ]] && die 1 "usage: michaelmux open [-c] [-z] [--base <ref>] <branch-or-pr>"

    require_deps
    if (( use_zmx )) && ! command -v zmx >/dev/null 2>&1; then
        die 2 "--zmx requested but zmx not on PATH"
    fi
    local root; root="$(repo_root)"

    local resolved kind branch wt
    resolved="$(resolve_input "$root" "$input")" || exit $?
    IFS=$'\t' read -r kind branch wt <<<"$resolved"

    if (( create )); then
        if [[ "$kind" != "branch" ]]; then
            die 1 "--create only applies to branches, not PRs"
        fi
        _create_branch_if_missing "$root" "$branch" "$base" || exit $?
    fi

    wt="$(_ensure_worktree "$root" "$branch" "$wt")" || exit $?

    local title; title="$(short_name_for_branch "$branch")"
    _open_or_focus_tab "$wt" "$title" "$use_zmx"
    aerospace_focus_workspace
    log "michaelmux: $wt"
}

# Creates $branch from $base (or origin's default branch) if it doesn't
# already exist locally or on origin. No-op if the branch already exists.
_create_branch_if_missing() {
    local root="$1" branch="$2" base="$3"

    if git -C "$root" rev-parse --verify "$branch" >/dev/null 2>&1; then
        return 0
    fi
    if git -C "$root" ls-remote --exit-code origin "$branch" >/dev/null 2>&1; then
        return 0
    fi

    if [[ -z "$base" ]]; then
        base="$(_default_base "$root")" \
            || die 2 "couldn't detect default base; pass --base <ref>"
    fi

    # Make sure the base is up to date when it's a remote-tracking ref.
    if [[ "$base" == origin/* ]]; then
        local remote_branch="${base#origin/}"
        git -C "$root" fetch origin "$remote_branch" >/dev/null 2>&1 \
            || die 1 "fetch origin $remote_branch failed"
    fi

    if ! git -C "$root" rev-parse --verify "$base" >/dev/null 2>&1; then
        die 1 "base ref '$base' not found"
    fi

    git -C "$root" branch --no-track "$branch" "$base" >/dev/null \
        || die 1 "failed to create branch '$branch' from '$base'"
    log "michaelmux: created '$branch' from '$base'"
}

# Prints the default base ref (e.g. origin/master) or empty + nonzero on failure.
_default_base() {
    local root="$1" head_ref
    head_ref="$(git -C "$root" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null)" || {
        git -C "$root" remote set-head origin --auto >/dev/null 2>&1 || return 1
        head_ref="$(git -C "$root" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null)" || return 1
    }
    printf '%s\n' "${head_ref#refs/remotes/}"
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
    if git -C "$root" worktree add "$wt" "$branch" >/dev/null 2>"$err"; then
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
    local wt="$1" title="$2" use_zmx="${3:-0}" uow="${4:-}"
    local tab_id; tab_id="$(kitty_tab_for_cwd "$wt")"
    if [[ -n "$tab_id" ]]; then
        kitty @ focus-tab --match "id:$tab_id"
        _cd_active_window_if_needed "$tab_id" "$wt"
        return
    fi

    local env_args=()
    [[ -n "$uow" ]] && env_args+=(--env "MICHAELMUX_UOW_NAME=$uow")

    if (( use_zmx )); then
        kitty @ launch --type=tab \
            --tab-title "$title" \
            --cwd "$wt" \
            ${env_args[@]+"${env_args[@]}"} \
            zmx attach "$title" >/dev/null
    else
        kitty @ launch --type=tab \
            --tab-title "$title" \
            --cwd "$wt" \
            ${env_args[@]+"${env_args[@]}"} >/dev/null
    fi
}

# If the active window in $tab_id isn't already at $wt, and it's sitting at a
# shell prompt, send a `cd $wt` so the shell follows. If a foreground process
# is running, skip — we don't want to inject text into vim/less/etc.
_cd_active_window_if_needed() {
    local tab_id="$1" wt="$2"
    local info
    info="$(kitty @ ls 2>/dev/null \
        | jq -r --argjson tab "$tab_id" '
            .[] | .tabs[]
            | select(.id == $tab)
            | .windows[]
            | select(.is_active == true)
            | [.id, .cwd, (.at_prompt // false)]
            | @tsv
        ' | head -1)" || return 0
    [[ -z "$info" ]] && return 0

    local win_id cwd at_prompt
    IFS=$'\t' read -r win_id cwd at_prompt <<<"$info"

    [[ "$cwd" == "$wt" ]] && return 0

    if [[ "$at_prompt" != "true" ]]; then
        log "michaelmux: window busy, not cd'ing — current dir: $cwd"
        return 0
    fi

    kitty @ send-text --match "id:$win_id" "cd ${wt@Q}"$'\n' >/dev/null
}
