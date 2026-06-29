# shellcheck shell=bash

cmd_rn() {
    local name=""
    while (( $# )); do
        case "$1" in
            -h|--help) cat <<EOF; return 0
usage: michaelmux rn [<name>]

Renames the current kitty tab's title to the michaelmux name.

With <name>: uses it verbatim.
No <name>:   uses \$MICHAELMUX_UOW_NAME if set, else the current git branch
             with its \`michael/\` prefix stripped.
EOF
                ;;
            --) shift; name="${1:-}"; break ;;
            -*) die 1 "unknown flag: $1" ;;
            *)  name="$1"; shift ;;
        esac
    done

    command -v kitty >/dev/null 2>&1 || die 2 "missing dependency: kitty"
    kitty @ ls >/dev/null 2>&1 \
        || die 2 "kitty @ ls failed — add \`listen_on unix:/tmp/kitty-\$USER\` to kitty.conf and restart kitty"

    if [[ -z "$name" ]]; then
        if [[ -n "${MICHAELMUX_UOW_NAME:-}" ]]; then
            name="$MICHAELMUX_UOW_NAME"
        else
            local branch
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" \
                || die 2 "no <name> given, no \$MICHAELMUX_UOW_NAME, and not in a git repo"
            name="$(short_name_for_branch "$branch")"
        fi
    fi

    [[ -n "$name" ]] || die 1 "couldn't determine a name to set"

    kitty @ set-tab-title "$name"
    log "michaelmux: renamed tab to '$name'"
}
