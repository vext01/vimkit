let hostname = hostname()
" Can be used for per-host config
" if hostname != "kryten.home"
" <stuff>
" endif


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Pkg manager itself
Plugin 'gmarik/Vundle.vim'

if match(hostname(), "wilfred") != -1
Plugin 'vimwiki'
Plugin 'lervag/vim-latex'
Plugin 'morhetz/gruvbox' " colours
Plugin 'abra/vim-abra' " colours
Plugin 'altercation/vim-colors-solarized' " colours
endif
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'mileszs/ack.vim'
Plugin 'mattn/webapi-vim' " for gist
Plugin 'mattn/gist-vim'
Plugin 'vim-scripts/BufOnly.vim'
Plugin 'tomtom/tlib_vim'
Plugin 'kien/ctrlp.vim'
Bundle 'FelikZ/ctrlp-py-matcher'
Plugin 'davidhalter/jedi-vim'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'nvie/vim-flake8'
Plugin 'vext01/theunixzoo-vim-colorscheme' " colours

call vundle#end()

filetype on
filetype indent on
filetype plugin on

" Misc
"set number
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nocompatible
set autoindent		" always set autoindenting on
set nobackup
set hlsearch
set backspace=indent,eol,start " backspace in insert mode

" open file at last place you were
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Mappings
map <C-h> :make!<cr>
map <C-1> :set background=dark<cr>
map <C-2> :set background=light<cr>
map <C-c> i---8<---<cr>--->8---<esc>O
map ;c i#include <stdio.h>#include <stdlib.h>intmain(int argc, char **argv){	return (EXIT_SUCCESS);}<esc><<
map ;w :!fmt -76<cr>
map ;s :%s/\s\+$//e<cr>
map <C-j> :syntax spell toplevel<cr>:set spell!<cr>

set nocursorline

set cmdheight=1 " for annoying :Exp prompt
"set scrolloff=5

" arduino
au BufRead,BufNewFile *.ino set filetype=cpp

" I hate terminal bell
set vb t_vb=

se t_Co=16
syntax on
colors theunixzoo
set colorcolumn=80

" Spelling
setlocal spell spelllang=en_gb
set nospell

" CTRL-P
let g:ctrlp_working_path_mode = ''
let g:ctrlp_by_filename = 0
let g:ctrlp_regexp = 0
let g:ctrlp_match_window = 'order:ttb,min:10,max:40'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(pyc|o|so|orig)$',
	\ }
nmap ` :CtrlPBuffer<cr>
nmap <tab> :CtrlPMixed<cr>

" jedi-vim
let g:jedi#popup_on_dot=0
let g:jedi#use_tabs_not_buffers=0

" copy and paste sanity
vmap <C-c> "+y
vmap <C_x> "+c
vmap <C_v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" synctex + zathura support
function! Synctex()
	" remove 'silent' for debugging
	execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:syncpdf
endfunction
map <C-enter> :call Synctex()<cr>

set nofoldenable

let g:tex_flavor='latex'
