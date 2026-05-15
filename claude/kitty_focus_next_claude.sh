#!/usr/bin/env bash
# Focus the next kitty tab/window that has a pending bell (needs_attention).
# Kitty auto-clears the bell state on focus, so repeated invocations cycle
# through all attention-flagged tabs naturally.
#
# When invoked by `launch --type=background` from a kitty keybind, the
# process has no controlling TTY and no KITTY_LISTEN_ON env var, so we
# locate the kitty socket via the glob configured in `listen_on`.

set -euo pipefail

command -v kitty >/dev/null 2>&1 || exit 0

if [[ -n "${KITTY_LISTEN_ON:-}" ]]; then
    socket="$KITTY_LISTEN_ON"
else
    # Match `listen_on unix:/tmp/kitty-$USER` (kitty appends -<pid>).
    socket_path="$(ls -t /tmp/kitty-"${USER}"-* 2>/dev/null | head -1 || true)"
    [[ -z "$socket_path" ]] && exit 0
    socket="unix:$socket_path"
fi

kitty @ --to "$socket" focus-tab --match state:needs_attention >/dev/null 2>&1 || true
