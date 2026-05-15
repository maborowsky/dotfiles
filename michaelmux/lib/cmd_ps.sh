# shellcheck shell=bash

cmd_ps() {
    require_deps

    local kitty_json bell_ids zmx_sessions
    kitty_json="$(kitty @ ls 2>/dev/null || echo '[]')"
    bell_ids="$( { kitty @ ls --match-tab 'state:needs_attention' 2>/dev/null \
        | jq -r '.[].tabs[].id' 2>/dev/null; } | tr '\n' ' ' || true)"
    zmx_sessions="$(zmx list --short 2>/dev/null || true)"

    local fmt='%-3s %-4s %-20s %-32s %-24s %-4s %-3s %s\n'
    # shellcheck disable=SC2059
    printf "$fmt" WIN TAB TITLE CWD BRANCH BELL WT ZMX

    declare -A seen_zmx
    local home="$HOME"

    local row win tab title cwd zmx_in_tab
    while IFS=$'\t' read -r win tab title cwd zmx_in_tab; do
        [[ -z "$win" ]] && continue

        local short_cwd="${cwd/#$home/\~}"
        local branch worktree bell
        branch="$(_ps_branch "$cwd")"
        worktree="$(_ps_worktree "$cwd")"
        bell=""
        [[ " $bell_ids " == *" $tab "* ]] && bell="!"

        [[ -n "$zmx_in_tab" ]] && seen_zmx["$zmx_in_tab"]=1

        # shellcheck disable=SC2059
        printf "$fmt" "$win" "$tab" "$title" "$short_cwd" "$branch" "$bell" "$worktree" "$zmx_in_tab"
    done < <(_ps_kitty_rows "$kitty_json")

    local s
    while IFS= read -r s; do
        [[ -z "$s" || -n "${seen_zmx[$s]:-}" ]] && continue
        # shellcheck disable=SC2059
        printf "$fmt" "" "" "(zmx)" "" "" "" "" "$s"
    done <<<"$zmx_sessions"
}

_ps_kitty_rows() {
    local kitty_json="$1"
    jq -r '
        .[] as $os
        | $os.tabs[] as $tab
        | (($tab.active_window_history | last) // ($tab.windows[0].id // null)) as $aid
        | (($tab.windows | map(select(.id == $aid)) | first) // ($tab.windows[0] // null)) as $w
        | (($w.foreground_processes // []) | map(.cwd) | map(select(. != null and . != "")) | first // $w.cwd // "") as $cwd
        | ([ $tab.windows[]
             | .foreground_processes[]?
             | .cmdline
             | select(length >= 3)
             | select((.[0] | split("/") | last) == "zmx")
             | select(.[1] == "attach" or .[1] == "a")
             | .[2]
           ] | first // "") as $zmx
        | [
            $os.id,
            $tab.id,
            ($tab.title // "" | gsub("[\\t\\r\\n]"; " ")),
            ($cwd | gsub("[\\t\\r\\n]"; " ")),
            $zmx
          ]
        | @tsv
    ' <<<"$kitty_json"
}

_ps_branch() {
    local cwd="$1"
    [[ -d "$cwd" ]] || return 0
    local b
    if b="$(git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null)"; then
        printf '%s' "$b"
    elif b="$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)"; then
        printf '(%s)' "$b"
    fi
    return 0
}

_ps_worktree() {
    local cwd="$1"
    [[ -d "$cwd" ]] || return 0
    local gd cd
    gd="$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)" || return 0
    cd="$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)" || return 0
    [[ "$gd" != "$cd" ]] && printf '●'
    return 0
}

_ps_claude() {
    # ps aux | grep -i claude | grep -v grep
    :
}
