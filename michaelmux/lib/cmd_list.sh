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
