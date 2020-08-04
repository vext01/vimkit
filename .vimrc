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
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Language Support -- Python.
Plug 'hynek/vim-python-pep8-indent'
" Language Support -- Rust.
Plug 'rust-lang/rust.vim'
" Navigation/Buffers.
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'vim-scripts/BufOnly.vim'
Plug 'rhysd/clever-f.vim'
Plug 'christoomey/vim-tmux-navigator'
" Editing
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'tomtom/tcomment_vim'
Plug 'dyng/ctrlsf.vim'
" Misc
Plug 'jamessan/vim-gnupg'
Plug 'itchyny/lightline.vim'
Plug 'lfv89/vim-interestingwords'
Plug 'glts/vim-magnum' " needed for radical
Plug 'glts/vim-radical'
Plug 'djoshea/vim-autoread'
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

" Spelling
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

" Copy and paste sanity.
vmap <C-c> "+y
vmap <C_x> "+c
vmap <C_v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
nmap <space> :set paste!<cr>

" Insert scissor quotes.
imap <C-c> ---8<---<cr>--->8---<esc>O

" Insert a C program.
map ;c i#include <stdio.h>#include <stdlib.h>intmain(int argc, char **argv){return (EXIT_SUCCESS);}<esc><<

" Toggle line numbers.
map <leader>l :set number!<cr>

" Run make easily.
nmap <leader>m :make!<cr>

" Delete/change inside/around slash (e.g. 'di/')
onoremap <silent> i/ :<C-U>normal! T/vt/<CR>
onoremap <silent> a/ :<C-U>normal! F/vf/<CR>

" Turn off higlight search.
map <C-n> :noh<cr>

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

let g:fzf_preview_window = ''
nmap ` :Buffers<cr>
nmap <C-p> :Files<cr>


" ///
" /// Plugin: ultisnips
" ///

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


" ///
" /// Plugin: vim-gnupg
" ///

" I use only GnuPG version 2.
let g:GPGExecutable='/usr/local/bin/gpg2'


" ///
" /// Plugin: vim-ripgrep
" ///

nmap gs :Rg <C-R><C-W><cr>
nmap <leader>g :Rg 

" ///
" /// Plugin: lightline
" ///

let g:lightline = { 'colorscheme': 'solarized' }

" ///
" /// Plugin: easymotion.
" ///

" Word forward.
map <Leader><Leader>h <Plug>(easymotion-b)

" Word backward.
map <Leader><Leader>l <Plug>(easymotion-w)

" ///
" /// Plugin: languageclient-neovim
" ///

set hidden
if executable('rust-analyzer')
    let g:LanguageClient_serverCommands = {
            \ 'rust': ['rust-analyzer'],
    \ }
endif

" Hover turns off syntax highlight for some reason.
"nmap <silent>K <Plug>(lcn-hover)
let g:LanguageClient_useVirtualText="No"
nmap <silent> gd <Plug>(lcn-definition)

" ///
" /// System-local config.
" ///
"

source ~/.vim/local.vim

" ///
" /// Colours / syntax highlighting.
" /// We do this last, or weird stuff happens.
" ///

set t_Co=256
"colors solarized
colors commentary
syn sync minlines=300
syntax on
