" Note to self: if this is a fresh install, run :PluginInstall to install 
" Vundle deps.

" Add custom vim config directory to the runtime path
set rtp+=$HOME/.config/vim/

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
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'simnalamburt/vim-mundo'

" (required)
call vundle#end()
filetype plugin indent on

" Setup powerline status line
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

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

" Enable Solarized
set background=light
colorscheme solarized

" Disable folding in markdown files
let g:vim_markdown_folding_disabled = 1

" Fix auto folding in some file types
set foldmethod=indent
set foldlevel=20

" Show hidden files in nerdtree automatically
let NERDTreeShowHidden=1

" Load text bubbling
runtime bubble.vim

" Command for commenting out lines
command! -range -nargs=1 Comment :execute "'<,'>normal! <C-v>0I" . <f-args> . "<Esc><Esc>"

" Enable frontmatter in markdown files
let g:vim_markdown_frontmatter = 1

"'''''''''''''''''''''''''''''''''''''''''''''''"
"''                KEY BINDINGS               ''"
"'''''''''''''''''''''''''''''''''''''''''''''''"

" Space -> leader
nnoremap <SPACE> <Nop>
let mapleader=" "

map <C-n> :NERDTreeToggle<CR>

"SHIFT+← move to prev tab
map <Esc>[1;2D :tabprevious<CR>

"SHIFT+→ move to next tab
map <Esc>[1;2C :tabnext<CR>

"<A-k> moves lines up
noremap <A-k> ˚
nmap ˚ [e
xmap ˚ [e

"<A-j> moves lines down
noremap <A-j> ∆
nmap ∆ ]e
xmap ∆ ]e

" Comment out lines with <space>/
vmap <leader>/ :Comment 
nnoremap <leader>/ V:Comment 

map <C-g> :MundoToggle<CR>
