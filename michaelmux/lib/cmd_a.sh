# shellcheck shell=bash
# shellcheck source=cmd_open.sh
source "$MICHAELMUX_ROOT/lib/cmd_open.sh"
# shellcheck source=state.sh
source "$MICHAELMUX_ROOT/lib/state.sh"

cmd_a() {
    local jira="" pr="" use_zmx="${MICHAELMUX_USE_ZMX:-1}" name=""
    while (( $# )); do
        case "$1" in
            --jira)   jira="${2:-}"; shift 2 ;;
            --jira=*) jira="${1#--jira=}"; shift ;;
            --pr)     pr="${2:-}"; shift 2 ;;
            --pr=*)   pr="${1#--pr=}"; shift ;;
            -z|--zmx) use_zmx=1; shift ;;
            --no-zmx) use_zmx=0; shift ;;
            -h|--help) cat <<EOF; return 0
usage: michaelmux a [--jira <key>] [--pr <num-or-url>] [--no-zmx] <name>

Upserts a unit of work keyed by <name> into $MICHAELMUX_STATE.

New name:      creates branch michael/<name>, its worktree, opens a kitty tab
               running a zmx session named <name> at the worktree root
               (--no-zmx for a plain tab), records everything, then prints
               the entry.
Existing name: merges any --jira/--pr values into the entry and prints it.
               Nothing else is touched.
EOF
                ;;
            --) shift; name="${1:-}"; break ;;
            -*) die 1 "unknown flag: $1" ;;
            *)  name="$1"; shift ;;
        esac
    done

    [[ -z "$name" ]] && die 1 "usage: michaelmux a [--jira <key>] [--pr <num-or-url>] <name>"

    require_deps
    local root; root="$(uow_repo_root)"
    _state_init

    if _state_has "$name"; then
        _state_merge_flags "$name" "$jira" "$pr"
        _state_print "$name"
        return 0
    fi

    local branch="michael/$name"
    local wt="$root/.worktrees/$branch"
    _create_branch_if_missing "$root" "$branch" "" || exit $?
    wt="$(_ensure_worktree "$root" "$branch" "$wt")" || exit $?

    _state_insert "$name" "$branch" "$wt" "$root" "$jira" "$pr"

    _open_or_focus_tab "$wt" "$name" "$use_zmx" "$name"
    aerospace_focus_workspace
    _state_print "$name"
}
