let hostname = hostname()

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

if match(hostname(), "wilfred") != -1
Plug 'lervag/vim-latex'
Plug 'morhetz/gruvbox' " colours
Plug 'gregsexton/Atom' "colours
Plug 'altercation/vim-colors-solarized' " colours
endif
Plug 'rking/ag.vim'
Plug 'mattn/webapi-vim' " for gist
Plug 'mattn/gist-vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'davidhalter/jedi-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'nvie/vim-flake8'
Plug 'vext01/theunixzoo-vim-colorscheme' " colours
Plug 'jamessan/vim-gnupg'
Plug 'zah/nim.vim'
Plug 'rust-lang/rust.vim'

call plug#end()

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
map <C-j> :set spell!<cr>

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
let g:jedi#show_call_signatures=1

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
au BufRead,BufNewFile *.krun setfiletype python

:set nojoinspaces

let g:GPGExecutable='/usr/local/bin/gpg2'

set shiftwidth=4
set expandtab
set tabstop=4

" Spelling
hi SpellBad cterm=underline ctermfg=magenta ctermbg=none
hi SpellCap cterm=underline ctermfg=magenta ctermbg=none
hi SpellLocal cterm=underline ctermfg=magenta ctermbg=none
hi SpellRare cterm=underline ctermfg=magenta ctermbg=none
setlocal spell spelllang=en_gb
set spell

" No cursor keys
" combine with this:
" xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
"inoremap <Left>  <NOP>
"inoremap <Right> <NOP>
"inoremap <Up>    <NOP>
"inoremap <Down>  <NOP>
"nnoremap <Left>  <NOP>
"nnoremap <Right> <NOP>
"nnoremap <Up>    <NOP>
"nnoremap <Down>  <NOP>

