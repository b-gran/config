# Make sure everyone knows which editor is best
EDITOR=/usr/local/bin/vim

# Fix history
shopt -s histappend # append to history immediately
HISTSIZE=9000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignorespace:ignoredups
_bash_history_sync() {
  builtin history -a
  HISTFILESIZE=$HISTSIZE # fix history numbers when called from PROMPT_COMMAND
}
history() {
  _bash_history_sync
  builtin history "$@"
}
export PROMPT_COMMAND=_bash_history_sync

# Start up powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

# Command line colors.
export CLICOLOR=1

# Enable autocomplete for git.
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Load the bash utils in config
for f in ~/.config/bash/*.sh; do source $f; done

# If there's a local bash_profile, use it
local_bash_profile="$HOME/.local.bash_profile"
if [[ -f $local_bash_profile ]]; then 
    source $local_bash_profile
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Hack to fix nvm on tmux:
if [ -n $TMUX ]; then
  nvm use 9
fi
