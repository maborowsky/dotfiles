# shellcheck shell=bash

MICHAELMUX_STATE="${MICHAELMUX_STATE:-$HOME/.local/michaelmux.json}"

cmd_devcontainer() {
    local name=""
    while (( $# )); do
        case "$1" in
            -h|--help) cat <<EOF; return 0
usage: michaelmux devcontainer [<name>]

Runs \`devcontainer up --workspace-folder .\` in a worktree, in the foreground.

With <name>: looks the worktree up in $MICHAELMUX_STATE (the key from
             \`michaelmux a\`).
No <name>:   uses the current git worktree.
EOF
                ;;
            --) shift; name="${1:-}"; break ;;
            -*) die 1 "unknown flag: $1" ;;
            *)  name="$1"; shift ;;
        esac
    done

    command -v devcontainer >/dev/null 2>&1 \
        || die 2 "missing dependency: devcontainer (npm i -g @devcontainers/cli)"

    local wt
    if [[ -n "$name" ]]; then
        wt="$(_devcontainer_worktree_for_name "$name")" || exit $?
    else
        wt="$(git rev-parse --show-toplevel 2>/dev/null)" \
            || die 2 "no <name> given and not in a git worktree"
    fi

    [[ -d "$wt" ]] || die 1 "worktree not found: $wt"

    log "michaelmux: devcontainer up --workspace-folder . in $wt"
    ( cd "$wt" && devcontainer up --workspace-folder . )
}

# Print the worktree path recorded for a unit-of-work name, or die.
_devcontainer_worktree_for_name() {
    local name="$1"
    command -v jq >/dev/null 2>&1 || die 2 "missing dependency: jq"
    [[ -f "$MICHAELMUX_STATE" ]] \
        || die 1 "no state file at $MICHAELMUX_STATE; run \`michaelmux a $name\` first"

    local wt
    wt="$(jq -r --arg n "$name" '.[$n].worktree // empty' "$MICHAELMUX_STATE")" \
        || die 1 "failed to read $MICHAELMUX_STATE"
    [[ -n "$wt" ]] || die 1 "no entry for '$name' in $MICHAELMUX_STATE"
    printf '%s\n' "$wt"
}
