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
Plug 'robertmeta/nofrils'
Plug 'morhetz/gruvbox'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Language support.
Plug 'prabirshrestha/async.vim'    " Needed for vim-lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'ncm2/ncm2'                   " Nvim completion manager
Plug 'ncm2/ncm2-vim-lsp'           " Bridges vim-lsp and ncm2
Plug 'roxma/nvim-yarp'             " Remote plugin framework (needed for NCM2)
"Plug 'neovim/nvim-lspconfig'	   " Configurator for neovim-0.5 built-in lsp.
"Plug 'nvim-lua/diagnostic-nvim'	   " Extends nvim-lspconfig.
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
set mouse=a
set colorcolumn=80  " Mark long lines.
set number          " Enable number gutter.
set nofoldenable    " Disable folding.
set nojoinspaces    " Don't add extra spaces when joining lines.
set clipboard+=unnamedplus  " sync with system clipboard.
set undodir=~/.vim/undo_dir " Remember undo for each file.
set undofile                " ^^^
set inccommand=nosplit " live substitutions.

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
" /// Plugin: vim-lsp
" ///

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })

endif

if executable('rust-analyzer')
    if filereadable("x.py")
        " Rust compiler.
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'rust-analyzer',
                    \ 'cmd': {server_info->['rust-analyzer']},
                    \ 'allowlist': ['rust'],
                    \ 'workspace_config': {'rust-analyzer': {'checkOnSave': {'overrideCommand': './x.py check --json-output'}}},
                    \ })
    elseif filereadable("ykshim_client/Cargo.toml")
        " It's the yk repo.
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'rust-analyzer',
                    \ 'cmd': {server_info->['rust-analyzer']},
                    \ 'allowlist': ['rust'],
                    \ 'workspace_config': {'rust-analyzer': {'linkedProjects': ['internal_ws/Cargo.toml']}},
                    \ })
    else
        " Normal project.
        "
        " Either install rust-src from rustup or set RUST_SRC_PATH to the
        " `library` subdir of a rust source checkout.
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'rust-analyzer',
                    \ 'cmd': {server_info->['rust-analyzer']},
                    \ 'allowlist': ['rust'],
                    \ })
    endif
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <C-up> <Plug>(lsp-previous-diagnostic)
    nmap <buffer> <C-down> <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_signs_error = {'text': 'X'}
let g:lsp_signs_warning = {'text': '!'}
let g:lsp_signs_hint = {'test': '•'}

let g:lsp_diagnostics_float_cursor=1
let g:lsp_diagnostics_float_delay=0
let g:lsp_virtual_text_enabled=0
let g:lsp_diagnostics_virtual_text_enabled = 0

" ///
" /// Plugin vim-lspconfig
" ///

"if filereadable("x.py")
"lua <<EOF
"require('nvim_lsp').rust_analyzer.setup {
"  on_attach=require'diagnostic'.on_attach,
"  settings = {
"    ['rust-analyzer'] = {
"      checkOnSave = {
"        overrideCommand = {'./x.py', 'check', '--json-output'}
"      }
"    }
"  }
"}
"EOF
"else
"lua require'nvim_lsp'.rust_analyzer.setup{on_attach=require'diagnostic'.on_attach}
"endif
"
"nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
"
"autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

" ///
" /// Plugin diagnostic-nvim
" ///

"" Doesn't seem to work in ykrustc sadly.
"nnoremap <buffer> <C-up> :PrevDiagnosticCycle<cr>
"nnoremap <buffer> <C-down> :NextDiagnosticCycle<cr>
"
"" https://github.com/nvim-lua/diagnostic-nvim/issues/71
"command! CurrentLineDiagnostic lua require'jumpLoc'.openLineDiagnostics()
"nnoremap <buffer> <C-y> :CurrentLineDiagnostic<cr>

" ///
" /// Plugin: ncm2
" ///

autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
noremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" ///
" /// System-local config.
" ///
"

source ~/.vim/local.vim

" ///
" /// Colours / syntax highlighting.
" /// We do this last, or weird stuff happens.
" ///

"set t_Co=256
"let g:solarized_contrast="high"
"let g:solarized_termcolors=256
syntax on
set background=light
colors nofrils-acme
"colors solarized
"colors gruvbox
"colors commentary
syn sync minlines=300
