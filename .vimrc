set nocompatible

set background=dark
set backspace=indent,eol,start
set hidden
set list
set listchars=tab:>-,trail:$
set mouse=
set number
set scrolloff=3
set shiftround
set shiftwidth=4
set wildmenu
set wildoptions=pum
set wrap
set nolangremap
set noshowmatch

set expandtab
set smarttab

set timeout
set timeoutlen=1000
set ttimeoutlen=100

set laststatus=2
let &statusline = ' %f %m%r%h%w%=%y[col %v][row %l/%L]'

set hlsearch
set incsearch
nohlsearch

syntax enable
colorscheme habamax

filetype plugin indent on
autocmd FileType html,json setlocal shiftwidth=2

let mapleader = ","

nnoremap <leader>r :source $MYVIMRC<cr>

nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
