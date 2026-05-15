export XDG_CONFIG_HOME="$HOME/.config"
export GITHUB_PERSONAL_ACCESS_TOKEN=$(security find-generic-password -a "$USER" -s "github_pat" -w)
export CLAUDE_CODE_EFFORT_LEVEL=high

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
alias docker_login='echo $GITHUB_PERSONAL_ACCESS_TOKEN | docker login ghcr.io -u michael.borowsky@torchdental.com --password-stdin'

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

