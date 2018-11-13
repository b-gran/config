# Make sure everyone knows which editor is best
export EDITOR=/usr/local/bin/vim

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

# Add bin directory to path
export PATH=$PATH:$HOME/.config/git-bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

##################################
###           TMUX             ###
##################################

# This can be set from elsewhere (e.g. local script)
if [ -z $NODE_VERSION ]; then
  NODE_VERSION=10
fi

# Hack to fix nvm on tmux:
if [ -n $TMUX ]; then
  nvm use $NODE_VERSION
fi

# Ctrl-d should only exit after second press
IGNOREEOF=2

# Send keys to all tmux panes
unset -f _tmux_send_keys_all_panes_
_tmux_send_keys_all_panes_ () {
  for _pane in $(tmux list-panes -F '#P'); do
    tmux send-keys -t ${_pane} "$@"
  done
}
alias skap="_tmux_send_keys_all_panes_"

_tmux_send_command_all_panes () {
  _tmux_send_keys_all_panes_ "$@" Enter
}
alias sc="_tmux_send_command_all_panes"

unset -f _tmux_kill_sessions_ 
_tmux_kill_sessions_ () {
  tmux list-sessions | grep -E -v '\(attached\)$' | while IFS='\n' read line; do
    tmux kill-session -t "${line%%:*}"
  done
}
alias ks="_tmux_kill_sessions_"

# Load iterm integration if it's installed
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
