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
