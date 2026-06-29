# michaelmux

CLI for managing the kitty tab + git worktree for each branch or PR.

## Install

Symlink the dispatcher into your PATH. Example:

    ln -s ~/dotfiles/michaelmux/bin/michaelmux ~/.local/bin/michaelmux

## Requirements

- `git`, `jq`, `gh`, `kitty`, `aerospace` on PATH
- `kitty.conf` must contain both:

      allow_remote_control yes
      listen_on unix:/tmp/kitty-$USER

  Restart kitty after adding `listen_on`.

## Commands

    michaelmux a [--jira <key>] [--pr <num-or-url>] <name>
    michaelmux open <branch>          # or a GitHub PR URL
    michaelmux adopt [name] [--tab <id>]   # register an existing tab
    michaelmux list
    michaelmux goto <name>
    michaelmux devcontainer [<name>]  # `devcontainer up` in the worktree
    michaelmux rn [<name>]            # rename current kitty tab

### `a` — unit of work upsert

`michaelmux a <name>` is the entrypoint for a new unit of work. The name is
the canonical key everything else derives from:

- git branch: `michael/<name>`
- worktree: `<repo>/.worktrees/michael/<name>`
- devcontainer: `<name>`
- kitty tab title + zmx session: `<name>` (zmx is the default; `--no-zmx` for a plain tab)

State lives in `~/.local/michaelmux.json` (override with `MICHAELMUX_STATE`),
keyed by name. A new name creates the branch + worktree, opens the tab, and
records the entry. An existing name creates nothing — any `--jira`/`--pr`
flags are merged into the entry and it's printed.

### `adopt` — register an existing tab

`michaelmux adopt` brings a kitty tab you opened by hand under michaelmux,
after the fact. Where `a`/`open` create a branch, worktree, and tab, `adopt`
creates nothing — it records and labels what already exists.

It targets the tab it's run in (resolved via `$KITTY_WINDOW_ID`), or another
tab via `--tab <id>`. The unit-of-work name defaults to that tab's current
title; pass a positional `name` to override. It then:

- writes a state entry keyed by name, with `branch`/`worktree`/`repo` derived
  from the tab's active-window cwd (null branch/worktree outside a git repo;
  `repo` falls back to the cwd);
- sets the tab title to the name;
- exports `MICHAELMUX_UOW_NAME` into the active window if it's at a shell
  prompt (skipped silently if a foreground process is running).

`--jira`/`--pr` merge in the same way as `a`. An existing name only merges
those flags — git fields are left untouched, so re-adopting is safe.

### `devcontainer` — bring up the dev container

`michaelmux devcontainer <name>` cd's into the worktree recorded for `<name>`
in the state file and runs `devcontainer up --workspace-folder .` in the
foreground. With no `<name>` it uses the current git worktree. Requires the
`@devcontainers/cli` (`devcontainer`) on PATH.

### `rn` — rename the current tab

`michaelmux rn` sets the current kitty tab's title to the michaelmux name.
With no argument it uses `$MICHAELMUX_UOW_NAME` (set on tabs opened by
`michaelmux a`) if present, otherwise the current branch with its `michael/`
prefix stripped. Pass `<name>` to override.

## Environment

- `MICHAELMUX_STATE` — unit-of-work state file (default `~/.local/michaelmux.json`)
- `MICHAELMUX_WORKSPACE` — aerospace workspace to focus (default `2`)
- `MICHAELMUX_DEFAULT_REPO` — main repo root. When set, `a` always roots units
  of work here regardless of cwd; other commands fall back to it only when not
  run inside a git repo
- `MICHAELMUX_DEBUG=1` — verbose output (set `-x` in scripts)
