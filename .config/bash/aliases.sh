# LS
alias ll="ls -l"
alias la="ls -al"

# GIT
alias gs='git status'
alias gc='git commit'
alias gcam='git commit -am'
alias gl='git lg'
alias gd='git diff'
 
# Removes the most recent command from history.
alias rh='sed -i '\''$d'\'' ~/.bash_history'

# Copy the current directory into the system copy buffer
# Omits any newlines
alias gpwd="pwd | strip_newlines | pbcopy"
