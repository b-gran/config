#!/usr/bin/env bash

# Installs prerequisites needed to use the configs.
# Can be safely run multiple times. Backs up existing configs.
# Assumes homebrew is already installed.
# See https://github.com/nicksp/dotfiles/blob/master/setup.sh

# True if the given package is installed by homebrew
is_installed_brew() {
  brew ls --versions $1 > /dev/null
}

cmd_exists() {
  [ -x "$(command -v "$1")" ]
}

# True if the second argument is in the real path of the first
is_symlink_in_directory() {
  [[ -L $1 && $(realpath $1) =~ $2 ]]
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

# Create a symlink, without following links during creation 
link() {
  execute "ln -sfn $1 $2"  "linked $1 → $2..."
}

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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.config-backup-$(date | sed s/\ /_/g)"

# Update submodules
git submodule update --init --recursive
git submodule foreach git pull origin master

# Symlink submodules
link "$SCRIPT_DIR/submodules/Vundle.vim" "$SCRIPT_DIR/.config/.vim/bundle/Vundle.vim" 

declare -a FILES_TO_SYMLINK=(
  '.config'
  '.bash_profile'
  '.vimrc'
)

mkdir -p ${BACKUP_DIR}
print_info "Backup directory: $BACKUP_DIR"

# Symlink everything into home
for i in ${FILES_TO_SYMLINK[@]}; do
  source_file="$SCRIPT_DIR/$i"
  target_file="$HOME/$i"

  if ! is_symlink_in_directory $target_file $SCRIPT_DIR; then
    # Backup any current dotfiles that aren't symlinks from this directory
    if [ -e $target_file ]; then
      print_info "backing up $i..."
      mv $target_file $BACKUP_DIR/
    fi

    execute "ln -fs $source_file $target_file" "linked $target_file → $source_file..."
  else
    print_success "linked $target_file → $source_file..."
  fi
done

# Install vim plugins
execute "vim +PluginInstal +qall" "installed vim plugins..."

print_success "installation completed!"
