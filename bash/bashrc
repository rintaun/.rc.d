# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PAGER=less

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
export XDG_CONFIG_HOME="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

PS1='\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[1;34m\]\w\[\e[m\]$ '
PS1="$PS1"'$([ -n "$TMUX" ] && export TMUXPWD_$(tmux display -p "#D" | tr -d "%")=$PWD)'

alias tmux='tmux -2'

export PATH=$PATH:$HOME/bin

export GPG_TTY=$(tty)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# VirtualEnv (python) setup -- disabled in favor of asdf
# [[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && source /usr/local/bin/virtualenvwrapper.sh

# NVM (node) setup -- disabled in favor of asdf
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# YVM (yarn) setup -- disabled in favor of asdf
# export YVM_DIR=/home/rintaun/.yvm
# [ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# RVM (ruby) setup -- disabled in favor of asdf
# export PATH="$PATH:$HOME/.rvm/bin"
# [[ -s "~/.rvm/scripts/rvm" ]] && source ~/.rvm/scripts/rvm

# ASDF version manager setup
source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash
