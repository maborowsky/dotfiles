# shellcheck shell=bash
# shellcheck source=state.sh
source "$MICHAELMUX_ROOT/lib/state.sh"

cmd_adopt() {
    local tab="" jira="" pr="" name=""
    while (( $# )); do
        case "$1" in
            --tab)    tab="${2:-}"; shift 2 ;;
            --tab=*)  tab="${1#--tab=}"; shift ;;
            --jira)   jira="${2:-}"; shift 2 ;;
            --jira=*) jira="${1#--jira=}"; shift ;;
            --pr)     pr="${2:-}"; shift 2 ;;
            --pr=*)   pr="${1#--pr=}"; shift ;;
            -h|--help) cat <<EOF; return 0
usage: michaelmux adopt [name] [--tab <id>] [--jira <key>] [--pr <num-or-url>]

Registers an already-open kitty tab as a unit of work in $MICHAELMUX_STATE,
sets its title, and (if at a shell prompt) exports MICHAELMUX_UOW_NAME.

Target tab: the tab this runs in (via \$KITTY_WINDOW_ID), or --tab <id>.
name:       defaults to the target tab's current title.

Git fields are derived from the tab's active-window cwd (null outside a repo).
Creates nothing — for a new branch/worktree/tab use \`a\` or \`open\`.
An existing name only merges --jira/--pr; git fields are left untouched.
EOF
                ;;
            --) shift; name="${1:-}"; break ;;
            -*) die 1 "unknown flag: $1" ;;
            *)  name="$1"; shift ;;
        esac
    done

    require_deps
    _state_init

    local tab_id; tab_id="$(_adopt_target_tab "$tab")" || exit $?

    local win_id cwd at_prompt title
    IFS=$'\t' read -r win_id cwd at_prompt title < <(_adopt_active_window "$tab_id")
    [[ -z "$win_id" ]] && die 1 "couldn't read active window for tab $tab_id"

    [[ -z "$name" ]] && name="$title"
    [[ -z "$name" ]] && die 1 "no name given and tab has no title — pass a name"

    if _state_has "$name"; then
        _state_merge_flags "$name" "$jira" "$pr"
    else
        local branch wt repo
        IFS=$'\t' read -r branch wt repo < <(_adopt_git_fields "$cwd")
        _state_insert "$name" "$branch" "$wt" "$repo" "$jira" "$pr"
    fi

    kitty @ set-tab-title --match "id:$tab_id" "$name"

    if [[ "$at_prompt" == "true" ]]; then
        kitty @ send-text --match "id:$win_id" \
            "export MICHAELMUX_UOW_NAME=${name@Q}"$'\n' >/dev/null
    else
        log "michaelmux: window busy, not exporting MICHAELMUX_UOW_NAME"
    fi

    _state_print "$name"
}

# Resolve the target kitty tab id: explicit --tab, else the tab whose windows
# include $KITTY_WINDOW_ID.
_adopt_target_tab() {
    local want="$1"
    if [[ -n "$want" ]]; then
        printf '%s\n' "$want"
        return 0
    fi
    [[ -n "${KITTY_WINDOW_ID:-}" ]] \
        || die 1 "no --tab given and \$KITTY_WINDOW_ID unset — run inside a kitty tab or pass --tab <id>"
    local id
    id="$(kitty @ ls 2>/dev/null \
        | jq -r --argjson w "$KITTY_WINDOW_ID" '
            .[] | .tabs[] | select(.windows[]?.id == $w) | .id
        ' | head -1)"
    [[ -n "$id" ]] || die 1 "couldn't find the tab for window $KITTY_WINDOW_ID"
    printf '%s\n' "$id"
}

# Emit "win_id\tcwd\tat_prompt\ttitle" for the active window of a tab.
# cwd prefers the active window's foreground-process cwd (like cmd_ps).
_adopt_active_window() {
    local tab_id="$1"
    kitty @ ls 2>/dev/null \
        | jq -r --argjson tab "$tab_id" '
            .[] | .tabs[]
            | select(.id == $tab)
            | (.title // "") as $title
            | .windows
            | (map(select(.is_active == true)) | first // .[0]) as $w
            | [
                $w.id,
                (($w.foreground_processes // [] | map(.cwd)
                  | map(select(. != null and . != "")) | first)
                 // $w.cwd // ""),
                ($w.at_prompt // false),
                $title
              ] | @tsv
        ' | head -1
}

# Emit "branch\tworktree\trepo" for a cwd. Empty branch/worktree outside a repo.
# repo is the main worktree (always the first `git worktree list` entry), so a
# linked worktree resolves to its parent repo and the main checkout to itself.
_adopt_git_fields() {
    local cwd="$1" branch="" wt="" repo="$cwd"
    if [[ -d "$cwd" ]] && wt="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)"; then
        if branch="$(git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null)"; then
            :
        elif branch="$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)"; then
            branch="($branch)"
        fi
        local main
        main="$(git -C "$cwd" worktree list --porcelain 2>/dev/null \
            | awk '/^worktree /{print $2; exit}')"
        repo="${main:-$wt}"
    else
        wt=""
    fi
    printf '%s\t%s\t%s\n' "$branch" "$wt" "$repo"
}
