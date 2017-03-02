let hostname = hostname()

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"if match(hostname(), "wilfred") != -1
"endif
Plug 'vim-scripts/BufOnly.vim'
Plug 'altercation/vim-colors-solarized' " colours
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'hynek/vim-python-pep8-indent'
Plug 'nvie/vim-flake8'
Plug 'vext01/theunixzoo-vim-colorscheme' " colours
Plug 'jamessan/vim-gnupg'
Plug 'rust-lang/rust.vim'
Plug 'mhinz/vim-grepper'
"Plug 'vim-latex/vim-latex'

" Python completion/jumping
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'

" This can go after deiplete-jedi (or something else) supports jump to def
Plug 'davidhalter/jedi-vim'

" Don't forget to put fzf path into shell rc
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
"Plug 'junegunn/fzf.vim'


call plug#end()

filetype on
filetype indent on
filetype plugin on

" Misc
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
map <C-q> :Grepper<cr>

" Don't highlight the current line
set nocursorline

set cmdheight=1 " for annoying :Exp prompt

" arduino
au BufRead,BufNewFile *.ino set filetype=cpp

" I hate terminal bell
set vb t_vb=

" no mouse thanks
set mouse=

" Default terminal colour scheme
set t_Co=256
colors solarized
syntax on

" Mark long lines
set colorcolumn=80

" number gutter
set number
map <C-@> :set number!<cr>

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

" Fuzzy finder
"nmap ` :Buffers<cr>
"nmap <tab> :Files<cr>

" jedi-vim
" Kill when deoplete-jedi supports "jump to def"
let g:jedi#popup_on_dot=0
let g:jedi#use_tabs_not_buffers=0
let g:jedi#show_call_signatures=0

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1
"let g:deoplete#auto_complete_delay = 600
" from deoplete :help
inoremap <silent><expr> <C-space>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" copy and paste sanity
vmap <C-c> "+y
vmap <C_x> "+c
vmap <C_v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" delete/change inside/around slash
onoremap <silent> i/ :<C-U>normal! T/vt/<CR>
onoremap <silent> a/ :<C-U>normal! F/vf/<CR>

" I don't use folding, and it is slow anyway
set nofoldenable

" Any tex file I'm editing is latex
let g:tex_flavor='latex'

" .krun files are really Python
au BufRead,BufNewFile *.krun setfiletype python

" Don't add extra spaces when joining lines
:set nojoinspaces

" I use only gpg2
let g:GPGExecutable='/usr/local/bin/gpg2'

" Use space indent, unless overidden in a ftplugin
set tabstop=4
set expandtab
set shiftwidth=4

" Spelling
hi SpellBad cterm=underline ctermfg=magenta ctermbg=none
hi SpellCap cterm=underline ctermfg=magenta ctermbg=none
hi SpellLocal cterm=underline ctermfg=magenta ctermbg=none
hi SpellRare cterm=underline ctermfg=magenta ctermbg=none
setlocal spell spelllang=en_gb

set nospell  " off by default, use keybind to turn on

function HighLightWhitespace()
    hi! ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
endfunc
autocmd ColorScheme * call HighLightWhitespace()
autocmd FileType * call HighLightWhitespace()
autocmd FileType diff,mail hi clear ExtraWhitespace

" sync to system clipboard (nvim)
set clipboard+=unnamedplus

function WhatHighlight()
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunc

syn sync minlines=300

" anything you don't want in git, or that changes a lot, here
source ~/.vim/local.vim

set nofoldenable
