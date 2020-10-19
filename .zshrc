# source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"



# Default to neovim
export EDITOR='nvim'


export DEVROOT=/Users/michael/workspace
export GIVEWITH_LOCALHOST=~/workspace/givewith-localhost
export DOCKER_COMPOSE_PATH=~/workspace/givewith-localhost/docker-compose.yml

alias vim='nvim'
alias vi='nvim'

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




### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk


# Zinit load prezto stuff
zinit snippet PZT::modules/helper/init.zsh
zinit snippet PZT::modules/environment
zinit snippet PZT::modules/terminal
zinit snippet PZT::modules/editor
zinit snippet PZT::modules/history
zinit snippet PZT::modules/directory
zinit snippet PZT::modules/spectrum
zinit snippet PZT::modules/utility
zinit snippet PZT::modules/completion
zinit snippet PZT::modules/prompt
zinit snippet PZT::modules/ssh
# zinit snippet PZT::modules/docker

zinit light zsh-users/zsh-apple-touchbar

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
                # zdharma/history-search-multi-word \

# Theme (Pure)
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
