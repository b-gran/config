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

# Figure out if we're skipping backup
# The -b argument skips backup.
DO_BACKUP=true
while getopts "b" opt; do
  case $opt in
    b)
      DO_BACKUP=false
      ;;
  esac
done

# Warn if we're not backing up
if ! $DO_BACKUP; then
  printf "\e[0;33mWarning: \e[0m you are about to continue without a backup of your existing config.\n"
  read -p "Are you sure you want to continue (y/n)?" choice
  case "$choice" in
    y|Y ) ;;
    n|N ) echo "Exiting...";;
    * ) echo "Invalid input. Exiting...";;
  esac
fi

# Check homebrew
if ! cmd_exists brew; then
  result_die_failure 1 "please install homebrew and run again" "true"
fi

# Check coreutils
if ! is_installed_brew coreutils; then
  execute "brew install coreutils" "coreutils installed"
else
  print_success "coreutils already installed"
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

# Check git addon for powerline
execute "pip install powerline-gitstatus" "git powerline installed"

# Check git bash completion
execute "brew install bash-completion" "bash git completion installed"

# Install NVM
execute "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash" "nvm installed"

# Install fpp
execute "brew install fpp" "fpp installed"

# Install tree
execute "brew install tree" "tree installed"

# Install tmux
execute "brew install tmux" "tmux installed"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUPS="$HOME/.config-backups"
BACKUP_DIR="$BACKUPS/backup-$(date | sed s/\ /_/g)"

# Update submodules
execute "git submodule update --init --recursive" "updated submodules"
execute "git submodule foreach git pull origin master" "retrieved latest revisions"

# Symlink submodules
link "$SCRIPT_DIR/submodules/Vundle.vim" "$SCRIPT_DIR/.config/vim/bundle/Vundle.vim" 

declare -a FILES_TO_SYMLINK=(
  '.config'
  '.bash_profile'
  '.inputrc'
  '.vimrc'
  '.gitconfig'
)

if $DO_BACKUP; then
  mkdir -p ${BACKUP_DIR}
  print_info "Backup directory: $BACKUP_DIR"
fi

# Symlink everything into home
for i in ${FILES_TO_SYMLINK[@]}; do
  source_file="$SCRIPT_DIR/$i"
  target_file="$HOME/$i"

  if ! is_symlink_in_directory $target_file $SCRIPT_DIR; then
    # Backup any current dotfiles that aren't symlinks from this directory
    if $DO_BACKUP; then
      if [ -e $target_file ]; then
        print_info "backing up $i..."
        mv $target_file $BACKUP_DIR/
      fi
    fi

    execute "ln -fs $source_file $target_file" "linked $target_file → $source_file..."
  else
    print_success "linked $target_file → $source_file..."
  fi
done

# Install vim plugins
execute "vim +PluginInstall +qall" "installed vim plugins..."

# Install iTerm fonts
shopt -s nullglob
for config_path in .config/iterm/fonts/*; do
  name="${config_path##*/}"
  library_path="$HOME/Library/Fonts/$name"

  if [ ! -e "$library_path" ]; then
    execute "cp ${config_path} ${library_path}" "installed font '$name'"
  else
    print_success "font '$name' already installed"
  fi
done

print_success "installation completed!"
