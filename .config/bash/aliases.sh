# LS
alias ll="ls -l"
alias la="ls -al"

# GIT
alias gs='git status'
alias gc='git commit'
alias gcam='git commit -am'
alias gl='git lg'
alias gd='git diff'
alias gr='git recent 5'
alias git-root='cd `git rev-parse --show-toplevel`'

# Copy the current directory into the system copy buffer
# Omits any newlines
alias gpwd="pwd | strip_newlines | system_copy"

# View all branches
alias tiga='env TIG_DIFF_OPTS="-M -C --find-copies-harder" tig --all HEAD'

# Local branches & tags
tigl() {
  local branches
  local tags
  branches=($(git branch | sed 's/^[ *]*//'))
  tags=($(git tag))
  env TIG_DIFF_OPTS="-M -C --find-copies-harder" tig "${branches[@]}" "${tags[@]}" origin/master HEAD
}

# Improve lsof UX
alias 2lsof="lsof -P"

# Removes the most recent command from history.
alias rh='sed -i '\''$d'\'' ~/.bash_history'

fix_remote_branch () {
  git branch --set-upstream-to origin/$1
}
