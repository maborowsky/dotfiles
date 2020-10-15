source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export DEVROOT=/Users/michael/workspace
export GIVEWITH_LOCALHOST=~/workspace/givewith-localhost
export DOCKER_COMPOSE_PATH=~/workspace/givewith-localhost/docker-compose.yml

alias vim='nvim'

alias venv='source ~/workspace/venv/bin/activate'

alias gatus='git status'
alias gog='git log --oneline'
alias giff='git diff | vim -'

alias dk='source <($GIVEWITH_LOCALHOST/read_local_envs.sh); docker-compose -f $DOCKER_COMPOSE_PATH'
alias dkup='dk up -d'
alias dkl='dk logs -f'
alias dkr='dk restart'

# Display images (only works in Kitty terminal)
alias icat='kitty icat --align=left'
alias isvg='rsvg-convert | icat'



