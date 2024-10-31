export EDITOR='nvim'

alias vim="nvim"

alias cdw="cd ~/workspace"
alias cdn="cd ~/notes"

alias tab='kitty @ set-tab-title'

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# I think these add lines to kitty.conf
# kitty +kitten themes Kanagawa
# kitty +kitten themes Kanagawa_dragon

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Created by `pipx` on 2024-10-18 13:32:22
export PATH="$PATH:/Users/michaelborowsky/.local/bin"
