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
