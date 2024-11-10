zstyle ':completion:*:*:*:default' menu yes select search
# zsh-autocomplete instead of compinit
# zstyle ':completion:*' completer _expand _complete
# bindkey '\t' autosuggest-accept
autoload -Uz compinit
compinit
# source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Aliases
export EDITOR='nvim'

alias vim="nvim"

alias cdw="cd ~/workspace"
# alias cdn="cd ~/notes"
alias cdn="cd /Users/michaelborowsky/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/iCloud\ obsidian\ vault"
alias cdc="cd ~/.config"

alias tab='kitty @ set-tab-title'


# Put this before sourcing fzf
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Created by `pipx` on 2024-10-18 13:32:22
export PATH="$PATH:/Users/michaelborowsky/.local/bin"

eval "$(starship init zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
