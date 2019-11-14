" -------------------------------------------------------------------
"
" 8""""             88         8"""8            88   8
" 8     eeeee eeeee  8 eeeee   8   8 eeee eeeee 88   8 e  eeeeeee
" 8eeee 8   8 8   8    8   "   8e  8 8    8  88 88  e8 8  8  8  8
" 88    8e  8 8e  8    8eeee   88  8 8eee 8   8 "8  8  8e 8e 8  8
" 88    88  8 88  8       88   88  8 88   8   8  8  8  88 88 8  8
" 88eee 88ee8 88ee8    8ee88   88  8 88ee 8eee8  8ee8  88 88 8  8
"
" 8""""8
" 8    " eeeee eeeee eeee e  eeeee
" 8e     8  88 8   8 8    8  8   8
" 88     8   8 8e  8 8eee 8e 8e
" 88   e 8   8 88  8 88   88 88 "8
" 88eee8 8eee8 88  8 88   88 88ee8
"
"
" I ran Vim for decades, and I all have to show is this lousy config.
" -------------------------------------------------------------------


" ///
" /// Plugin Manager Setup
" ///
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Colour schemes.
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Language support.
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Language Support -- Python.
Plug 'hynek/vim-python-pep8-indent'
Plug 'nvie/vim-flake8'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
" Language Support -- Rust.
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'
" Navigation/Buffers.
Plug 'mhinz/vim-grepper'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'vim-scripts/BufOnly.vim'
" Misc
Plug 'jamessan/vim-gnupg'
Plug 'itchyny/lightline.vim'
call plug#end()

" ///
" /// Base Setup
" ///

filetype on
filetype indent on
filetype plugin on

set ruler		    " Show the cursor position all the time.
set showcmd		    " Display incomplete commands.
set incsearch		" Enable incremental searching.
set nocompatible    " It's not 1974.
set autoindent		" Always set autoindenting on.
set nobackup        " Don't write ~ files.
set hlsearch        " Highlight search term.
set backspace=indent,eol,start " Backspace in insert mode.
set nocursorline    " Don't highlight the current line.
set cmdheight=1     " Kill annoying :Exp prompt.
set vb t_vb=        " I hate terminal bell
"set mouse=         " No mouse.
set colorcolumn=80  " Mark long lines.
set number          " Enable number gutter.
set nofoldenable    " Disable folding.
set nojoinspaces    " Don't add extra spaces when joining lines.
set clipboard+=unnamedplus  " sync with system clipboard.
set undodir=~/.vim/undo_dir " Remember undo for each file.
set undofile                " ^^^


" Use spaces for indent, unless overidden elsewhere.
set tabstop=4
set expandtab
set shiftwidth=4

" Colours / syntax highlighting.
set t_Co=256
colors solarized
syn sync minlines=300
syntax on


" Spelling.
hi SpellBad cterm=underline ctermfg=magenta ctermbg=none
hi SpellCap cterm=underline ctermfg=magenta ctermbg=none
hi SpellLocal cterm=underline ctermfg=magenta ctermbg=none
hi SpellRare cterm=underline ctermfg=magenta ctermbg=none
setlocal spell spelllang=en_gb
set nospell  " Off by default, use keybinding to turn on.

" Highlight trailing whitespace.
function HighLightWhitespace()
    hi! ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
endfunc
autocmd ColorScheme * call HighLightWhitespace()
autocmd FileType * call HighLightWhitespace()
autocmd FileType diff,mail hi clear ExtraWhitespace

" Tell me what highlight class is applied under the cursor.
function WhatHighlight()
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunc

" ///
" /// Misc Mappings
" ///

" Strip trailing whitespace.
map ;s :%s/\s\+$//e<cr>

" Toggle spelling.
map <C-s> :set spell!<cr>

" Change window.
map <Tab> :wincmd w<CR>

" Copy and paste sanity.
vmap <C-c> "+y
vmap <C_x> "+c
vmap <C_v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
nmap <space> :set paste!<cr>

" Insert scissor quotes.
map <C-c> i---8<---<cr>--->8---<esc>O

" Insert a C program.
map ;c i#include <stdio.h>#include <stdlib.h>intmain(int argc, char **argv){return (EXIT_SUCCESS);}<esc><<

" Toggle line numbers.
map <leader>l :set number!<cr>

" Run make easily.
nmap <leader>m :make!<cr>

" Delete/change inside/around slash (e.g. 'di/')
onoremap <silent> i/ :<C-U>normal! T/vt/<CR>
onoremap <silent> a/ :<C-U>normal! F/vf/<CR>


" ///
" /// Misc Auto commands
" ///

" Arduino files are actually C++.
autocmd BufRead,BufNewFile *.ino set filetype=cpp

" Open file at last place you were.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Krun files are really Python.
au BufRead,BufNewFile *.krun setfiletype python

" Gopher stuff.
autocmd BufNewFile,BufRead gophermap set noexpandtab
autocmd BufNewFile,BufRead gophermap set tabstop=8
autocmd BufNewFile,BufRead gophermap set shiftwidth=8
autocmd BufNewFile,BufRead gophermap set textwidth=70


" ///
" /// Plugin: fzf
" ///

nmap ` :Buffers<cr>
nmap <C-p> :Files<cr>


" ///
" /// Plugin: ultisnips
" ///

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


" ///
" /// Plugin: jedi-vim
" ///
" /// Kill when deoplete-jedi supports "jump to def":
" /// https://github.com/deoplete-plugins/deoplete-jedi/issues/35
" ///

let g:jedi#popup_on_dot=0
let g:jedi#use_tabs_not_buffers=0
let g:jedi#show_call_signatures=0


" ///
" /// Plugin: deoplete
" ///

let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1

" Manual completion. From `:help deoplete`.
inoremap <silent><expr> <C-space>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}


" ///
" /// Plugin: vim-gnupg
" ///

" I use only GnuPG version 2.
let g:GPGExecutable='/usr/local/bin/gpg2'

" ///
" /// Plugin: grepper
" ///

let g:grepper = {}
let g:grepper.tools=['rg', 'ag']
let g:grepper.jump=1
let g:grepper.simple_prompt=1
nmap gs :Grepper -query <C-R><C-W><cr>
nmap <leader>g :Grepper<cr>

" ///
" /// Plugin: lightline
" ///

let g:lightline = { 'colorscheme': 'solarized' }


" ///
" /// Plugin: ale
" ///

let g:ale_rust_cargo_check_all_targets = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_linters = {'rust': ['rls']}
let g:ale_rust_rls_toolchain = 'nightly'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

" ///
" /// System-local config.
" ///

source ~/.vim/local.vim
