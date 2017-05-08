#!/usr/bin/env bash

# Installs prerequisites needed to use the configs.
# Assumes homebrew is already installed.
# See https://github.com/nicksp/dotfiles/blob/master/setup.sh

# True if the given package is installed by homebrew
is_installed_brew() {
  brew ls --versions $1 > /dev/null
}

cmd_exists() {
  [ -x "$(command -v "$1")" ]
}

# Print output in red
print_error() {
  printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

# Print output in purple
print_info() {
  printf "\n\e[0;35m $1\e[0m\n\n"
}

# Print output in yellow
print_question() {
  printf "\e[0;33m  [?] $1\e[0m"
}

# Print output in green
print_success() {
  printf "\e[0;32m  [✔] $1\e[0m\n"
}

# Prints a success message if the the code ($1) is 0
# Prints a warning message if the code ($1) is non-zero
# Exits if the code ($1) is non-zero and the last argument ($3) is true
result_die_failure() {
  [ $1 -eq 0 ] \
    && print_success "$2" \
    || print_error "$2"

  [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}

# Runs a command. On success, print the second argument.
execute() {
  $1 &> /dev/null
  result_die_failure $? "${2:-$1}"
}


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check homebrew
if ! cmd_exists brew; then
  result_die_failure 1 "please install homebrew and run again" "true"
fi

# Check python
if ! cmd_exists python; then
  print_info "installing python..."
  execute "brew install python" "python installed"
else
  print_success "python already installed"
fi

# Check powerline
if ! cmd_exists powerline; then
  # Don't use the --user flag if python is brew installed
  print_info "installing powerline..."
  if is_installed_brew python; then
    execute "pip install powerline-status" "powerline installed"
  else
    execute "pip install --user powerline-status" "powerline installed"
  fi
else
  print_success "powerline already installed"
fi

print_success "installation completed!"
