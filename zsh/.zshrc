export XDG_CONFIG_HOME="$HOME/.config"
export GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token 2>/dev/null)
# Disabled: exporting CLAUDE_CODE_OAUTH_TOKEN forces Claude Code into token-auth ("Claude API")
# on every cold start, overriding subscription login. Let Claude Code read the keychain itself.
# export CLAUDE_CODE_OAUTH_TOKEN=$(security find-generic-password -a "$USER" -s "Claude Code-credentials" -w | jq -r '.claudeAiOauth.accessToken')
# export CLAUDE_CODE_EFFORT_LEVEL=high

# PATH
typeset -U path
path=(
  $HOME/go/bin              # go install destinations (store, etc.)
  # /opt/homebrew/opt/postgresql@12/bin
  $path
)

setopt SHARE_HISTORY

# zsh picks vi mode when $EDITOR/$VISUAL contains "vi" (nvim qualifies),
# which collides with nvim terminal-mode <Esc>. Force emacs keys.
bindkey -e

if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  source $HOME/.config/wezterm/wezterm.sh
fi


# michaelmux
export MICHAELMUX_DEFAULT_REPO="$HOME/src/torchweb"
alias mm_ps="michaelmux ps"
alias mmps="michaelmux ps"
alias mm="michaelmux"
# function mm() {
#     local uow_name="$2"
#     if [[ "$1" == "a" ]]; then
#         shift
#         michaelmux a "$@"
#     elif [[ "$1" == "ps" ]]; then
#         michaelmux ps
#     elif [[ "$1" == "cw" ]]; then
#         if [[ -d .worktrees/"$uow_name" ]]; then
#             : # worktree already exists, just switch into it
#         elif git show-ref --verify --quiet refs/heads/michael/"$uow_name"; then
#             git worktree add .worktrees/"$uow_name" michael/"$uow_name"
#         else
#             git worktree add -b michael/"$uow_name" .worktrees/"$uow_name"
#         fi
#         cd .worktrees/"$uow_name"
#     fi
# }

# Aliases
alias vim=nvim

alias cdw="cd ~/src/torchweb/.worktrees/"
alias cds="cd ~/src"
alias cdsrc="cd ~/src"
alias cdt="z ~/src/torchweb/"
# alias cdt="cd ~/src/torchweb/; source ./.venv/bin/activate"
alias cdc="cd ~/dotfiles/"
alias cdcn="cd ~/dotfiles/nvim"
alias cdn="cd ~/notes/"

alias web-exec="docker compose exec webapp /bin/bash"

# todo: docker compose from anywhere
alias dkup="docker compose up --detach"
alias dkdown="docker compose down"
alias webattach="docker container attach webapp --sig-proxy false"
alias init_localstack="docker exec webapp python manage.py aws_utils init_localstack"
alias run_celery_task="docker exec webapp python manage.py debug run_task"
alias barry_poll_output="docker exec webapp python manage.py debug run_task --task torchweb.workflow.periodic.barry.poll_output_queue"
alias solr_reindex="docker exec webapp python manage.py search batch_sync_reindex_products --num-batches 5"
alias solr_suggestions="docker exec webapp python manage.py search rebuild_suggestions"

# Docker
alias docker_login='echo $GITHUB_PERSONAL_ACCESS_TOKEN | docker login ghcr.io -u maborowsky --password-stdin'

# kubernetes
alias kubectl_context="kubectl config current-context"

# Minikube
alias mkstart="minikube start --memory=7800 --cpus=4"
alias mk_docker_env='eval $(minikube docker-env)'
alias mk_image_build="minikube image build -t torchbase:latest ."
alias mkdash="minikube dashboard"

# Helm
alias helm_upgrade="helm upgrade --install torchweb ./helm -f deploy/local.yaml --set image.repository=torchbase"

# Git
alias gog='git log --pretty=format:"%h%x09%an%x09%ad%x09%s"'

review() {
  local branch=$1
  if [[ -z $branch ]]; then
    echo "usage: review <branch>" >&2
    return 1
  fi
  local root
  root=$(git rev-parse --show-toplevel) || return
  git fetch origin "$branch" || return
  local path="$root/.worktrees/reviews/${branch:t}"
  git worktree add "$path" "$branch" || return
  cd "$path"
  echo "run in nvim: :Octo review start"
}

# GitHub
function mypr() {
  gh pr list --author @me --json number,title,reviewDecision,statusCheckRollup --jq '
    ["#", "Title", "Review", "CI"],
    ["--", "-----", "------", "--"],
    (.[] |
      (.reviewDecision | if . == "APPROVED" then "Approved"
        elif . == "CHANGES_REQUESTED" then "Changes requested"
        elif . == "REVIEW_REQUIRED" then "Review required"
        else . end) as $review |
      ([.statusCheckRollup[]? | {status, conclusion}] | group_by(.conclusion) |
        map(
          (.[0].conclusion | if . == "SUCCESS" then "passed"
            elif . == "FAILURE" then "failed"
            elif . == "SKIPPED" then "skipped"
            elif . == "" then "in progress"
            else . end) as $label |
          "\(length) \($label)"
        ) | join(", ")) as $ci |
      [(.number | tostring), .title, $review, $ci]
    ) | @tsv
  ' | column -t -s $'\t'
}

# Python config
export PYTHONBREAKPOINT="ipdb.set_trace"


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/michaelborowsky/.docker/completions $fpath)
# End of Docker CLI completions

autoload -Uz compinit
compinit


# fzf worktrees - WIP
# (cds && git worktree list | fzf | awk '{print $1}')
# from: https://www.reddit.com/r/ClaudeAI/comments/1llq3d0/quick_jump_between_worktrees_with_claude_code_fzf/
lw() {
  local roots=(
    "$HOME/src/torchweb"
  )

  local all_paths=()
  for p in "${roots[@]}"; do
    if [ -d "$p/.git" ]; then
      all_paths+=("$p")
      if git -C "$p" worktree list &>/dev/null; then
        while IFS= read -r wt; do
          all_paths+=("$wt")
        done < <(git -C "$p" worktree list --porcelain | grep '^worktree ' | awk '{print $2}')
      fi
    fi
  done

  local selected=$(printf '%s\n' "${all_paths[@]}" | sort -u | fzf)
  [ -n "$selected" ] && cd "$selected"
}

# Abduco/Tmux/zmx
# trying out abduco but it's annoying that <C-\> conflicts with terminal in nvim
alias abduco='abduco -e ^b'
alias zexit='zmx kill $ZMX_SESSION'
function zmx_git_branch() {
    local branch_name=$(git symbolic-ref --short HEAD)
    local short="${branch_name#michael/}"
    kitten @ set-tab-title "$short"
    zmx a "$short"
}
function tabtitle() {
    local branch_name=$(git symbolic-ref --short HEAD)
    kitten @ set-tab-title "${branch_name#michael/}"
}
export ABDUCO_CMD='zsh'
# ZMX_DETACH_KEY=ctrl-b
# zmx also uses <c-\> which is annoying
# zmx completion
if command -v zmx &> /dev/null; then
  eval "$(zmx completions zsh)"
fi

# zmx fzf -- from https://github.com/neurosnap/zmx
zmx-select() {
  local display
  display=$(zmx list 2>/dev/null | while IFS=$'\t' read -r name pid clients created dir; do
    name=${name#session_name=}
    pid=${pid#pid=}
    clients=${clients#clients=}
    dir=${dir#started_in=}
    printf "%-20s  pid:%-8s  clients:%-2s  %s\n" "$name" "$pid" "$clients" "$dir"
  done)

  local output query key selected session_name
  output=$({ [[ -n "$display" ]] && echo "$display"; } | fzf \
    --print-query \
    --expect=ctrl-n \
    --height=80% \
    --reverse \
    --prompt="zmx> " \
    --header="Enter: select | Ctrl-N: create new" \
    --preview='zmx history {1}' \
    --preview-window=right:60%:follow \
  )
  local rc=$?

  query=$(echo "$output" | sed -n '1p')
  key=$(echo "$output" | sed -n '2p')
  selected=$(echo "$output" | sed -n '3p')

  if [[ "$key" == "ctrl-n" && -n "$query" ]]; then
    session_name="$query"
  elif [[ $rc -eq 0 && -n "$selected" ]]; then
    session_name=$(echo "$selected" | awk '{print $1}')
  elif [[ -n "$query" ]]; then
    session_name="$query"
  else
    return 130
  fi

  zmx attach "$session_name"
}


# FZF
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# fzf-git
source ~/.config/fzf-git.sh

eval "$(zoxide init zsh)"

# Starship
eval "$(starship init zsh)"


# direnv
eval "$(direnv hook zsh)"

