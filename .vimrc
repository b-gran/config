" Note to self: if this is a fresh install, run :PluginInstall to install 
" Vundle deps.

" Add custom vim config directory to the runtime path
set rtp+=~/.config/vim/

" Vundle pre-requisites (required)
set nocompatible
filetype off

" Vundle Startup (required)
set rtp+=~/.config/vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'       " (required) enables Vundle
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Helcaraxan/schemalang-vim'

" (required)
call vundle#end()
filetype plugin indent on

" Tab is 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Convert tab -> space
set expandtab

" Syntax highlighting
syntax enable

" Line numbers
set number

" Command in bottom bar
set showcmd

" Highlighting matching syntax pairs
set showmatch

" Move visually (instead of line-by-line)
nnoremap j gj
nnoremap k gk

" Show row & column no.
set ruler

" Enable spell checking for some file types
autocmd FileType latex,tex,md,markdown,text,txt setlocal spell

" Solarized colors in gui
if has("gui_running")
  set background=light
  colorscheme solarized
endif
