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

    michaelmux open <branch>          # or a GitHub PR URL
    michaelmux list
    michaelmux goto <name>

## Environment

- `MICHAELMUX_WORKSPACE` — aerospace workspace to focus (default `2`)
- `MICHAELMUX_DEFAULT_REPO` — fallback repo root when not run inside a git repo
- `MICHAELMUX_DEBUG=1` — verbose output (set `-x` in scripts)
