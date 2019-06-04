# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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

PS1="$PS1"'$([ -n "$TMUX" ] && export TMUXPWD_$(tmux display -p "#D" | tr -d %)=$PWD)'

alias tmux='tmux -2'

[[ -s "/usr/local/bin/virtualenvwrapper.sh" ]] && source /usr/local/bin/virtualenvwrapper.sh

[[ -s "~/.rvm/scripts/rvm" ]] && source ~/.rvm/scripts/rvm
PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
