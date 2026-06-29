# shellcheck shell=bash
# Unit-of-work state file ($MICHAELMUX_STATE) helpers, shared by cmd_a and
# cmd_adopt. State is a JSON object keyed by unit-of-work name.

MICHAELMUX_STATE="${MICHAELMUX_STATE:-$HOME/.local/michaelmux.json}"

_state_init() {
    if [[ ! -f "$MICHAELMUX_STATE" ]]; then
        mkdir -p "$(dirname "$MICHAELMUX_STATE")"
        printf '{}\n' > "$MICHAELMUX_STATE"
    fi
}

_state_has() {
    jq -e --arg n "$1" 'has($n)' "$MICHAELMUX_STATE" >/dev/null
}

# Rewrite the state file through a jq filter, atomically.
_state_write() {
    local tmp; tmp="$(mktemp)"
    if jq "$@" "$MICHAELMUX_STATE" > "$tmp"; then
        mv "$tmp" "$MICHAELMUX_STATE"
    else
        rm -f "$tmp"
        die 1 "failed to update $MICHAELMUX_STATE"
    fi
}

_state_insert() {
    local name="$1" branch="$2" wt="$3" repo="$4" jira="$5" pr="$6"
    _state_write \
        --arg n "$name" --arg branch "$branch" --arg wt "$wt" \
        --arg repo "$repo" --arg jira "$jira" --arg pr "$pr" \
        '.[$n] = {
            branch:       (if $branch == "" then null else $branch end),
            worktree:     (if $wt     == "" then null else $wt     end),
            repo:         $repo,
            devcontainer: $n,
            jira:         (if $jira == "" then null else $jira end),
            pr:           (if $pr   == "" then null else $pr   end),
            created_at:   (now | todate)
        }'
}

_state_merge_flags() {
    local name="$1" jira="$2" pr="$3"
    [[ -z "$jira" && -z "$pr" ]] && return 0
    _state_write --arg n "$name" --arg jira "$jira" --arg pr "$pr" \
        '.[$n] += ((if $jira != "" then {jira: $jira} else {} end)
                 + (if $pr   != "" then {pr:   $pr}   else {} end))'
}

_state_print() {
    jq --arg n "$1" '{($n): .[$n]}' "$MICHAELMUX_STATE"
}
