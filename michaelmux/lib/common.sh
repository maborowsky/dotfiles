# shellcheck shell=bash

log()  { printf '%s\n' "$*" >&2; }
die()  { local code="$1"; shift; log "michaelmux: $*"; exit "$code"; }

require_deps() {
    local missing=()
    for dep in git jq gh kitty aerospace zmx; do
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

# Short, human-friendly name for a branch — matches the zmx_git_branch zshrc
# helper: strip a leading "michael/" prefix. Used for both the kitty tab title
# and the zmx session name.
short_name_for_branch() {
    local branch="$1"
    printf '%s\n' "${branch#michael/}"
}

aerospace_focus_workspace() {
    local ws="${MICHAELMUX_WORKSPACE:-2}"
    aerospace workspace "$ws" >/dev/null 2>&1 || log "aerospace workspace $ws failed"
}
