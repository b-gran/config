# `config`

My personal MacOS configuration and dotfiles.

Inspired by https://github.com/nicksp/dotfiles and https://github.com/kaicataldo/dotfiles.

## What's included
* A basic `.bash_profile` with a few custom utilities in `.config/bash`
* A bash prompt with [powerline](https://github.com/powerline/powerline)
* A `.vimrc` with [Vundle](https://github.com/VundleVim/Vundle.vim)
* [solarized](http://ethanschoonover.com/solarized) color scheme for `vim` and `iTerm`

## Prerequisites
* Must be running MacOS or OS X
* `git` with submodule support
* Install [homebrew](https://brew.sh/)
    * The install will abort if `brew` isn't on the `PATH`
* Install `vim`

## Installation

It doesn't matter where this config repository is on the filesystem. The installation process will handle symlinking everything into `$HOME`.

#### 1 - Clone the repository and run the install script

```
# Choose a location for the config. Then:
git clone https://github.com/b-gran/config.git
cd config
./install.sh
```

Any configuration files that would be overwritten are backed up automatically.
__It's safe to run the installation script multiple times.__

#### 2 - Configure `iTerm`

Open `iTerm` and navigate to `Preferences... > General > Preferences`. Tick the 
`"Load preferences from a custom folder or URL"` checkbox. Then in the box to the right, enter or select the path to the `iTerm` config:
```
# Path to the iterm config folder within this repo
path/to/config/repo/.config/iterm/
```

## Local config updates

A local `.bash_profile` is loaded automatically from `$HOME/.local.bash_profile`.

The `$HOME/.vim` directory isn't modified, so you can make changes to that.
