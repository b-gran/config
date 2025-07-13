" Note to self: if this is a fresh install, run :PluginInstall to install
" Vundle deps.

" the python path is set when vim is built. I'm currently using 3.13 so this is hardcoded.
let pyenv_site_packages = trim(system('pyenv prefix 3.13')) . '/lib/python3.13/site-packages'
python3 import sys, os, vim
python3 p = vim.eval('pyenv_site_packages')
python3 if os.path.isdir(p) and p not in sys.path: sys.path.insert(0, p)

if has('termguicolors')
    set termguicolors
endif

" Fallback for terminals that only do 256 colours
if !exists('$COLORTERM') || index(['truecolor', '24bit'], $COLORTERM) < 0
    set t_Co=256
endif

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
Plugin 'lifepillar/vim-solarized8'
Plugin 'Helcaraxan/schemalang-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/fzf'
Plugin 'simnalamburt/vim-mundo'
Plugin 'leafgarland/typescript-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'herringtondarkholme/yats.vim'
Plugin 'othree/yajs.vim'
Plugin 'valloric/youcompleteme'

" (required)
call vundle#end()
filetype plugin indent on

" Enable mouse
set mouse=a

" Setup powerline status
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

" Highlighting
set showmatch " Matching syntax pairs
set hlsearch " Matching search terms

" Move visually (instead of line-by-line)
nnoremap j gj
nnoremap k gk

" Show row & column no.
set ruler

" Enable spell checking for some file types
autocmd FileType latex,tex,md,markdown,text,txt setlocal spell

" Enable Solarized (variant based on the host terminal)
if exists('$TERM_PROGRAM') && $TERM_PROGRAM ==# 'vscode'
  set background=dark
else
  set background=light
endif
autocmd vimenter * ++nested colorscheme solarized8

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

" Command for copying the contents of the current file
" TODO: support non-MacOS
command! Copy :execute "!cat % | pbcopy"

" Command for changing CWD to current file
command! CDC cd %:p:h

" Enable frontmatter in markdown files
let g:vim_markdown_frontmatter = 1

" Show "hidden" (i.e. starting with a dot) files in fzf. Requires ag to be on the path.
let $FZF_DEFAULT_COMMAND = "rg --files --glob '!.git'"

" Show the changes made to the current file since it was last saved
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

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

" Toggles the undo history panel
map <C-g> :MundoToggle<CR>

" Clear the latest search
map <leader>c :noh<CR>

" Open case-insensitive searches with alt
map ÷ /\c
map ¿ ?\c

" File searching
nnoremap <leader>f :call fzf#run({ 'sink': 'e', 'window': 'enew' })<cr>

" Save & close file commands
nnoremap <leader>q :q!<CR>
nnoremap <leader>x :xa<CR>
nnoremap <leader>w :wa<CR>
nnoremap <leader>o :only<CR>

" Create new tabs
map <leader>T :tabnew<CR>
