" Vim colorscheme template file
" Author: Gerardo Galindez <gerardo.galindez@gmail.com>
" Maintainer: Gerardo Galindez <gerardo.galindez@gmail.com>
" Notes: To check the meaning of the highlight groups, :help 'highlight'

" The following (not git tracked) file should do either:
" `set background=dark` or `set background=light`
source ~/.vim/background.vim

highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="commentary"

"----------------------------------------------------------------
" General settings                                              |
"----------------------------------------------------------------
"----------------------------------------------------------------
" Syntax group   | Foreground    | Background    | Style        |
"----------------------------------------------------------------

" --------------------------------
" Editor settings
" --------------------------------
if &background == "light"
hi Normal          ctermfg=green    ctermbg=none    cterm=none
else
hi Normal          ctermfg=gray    ctermbg=none    cterm=none
endif

hi Cursor          ctermfg=none    ctermbg=none    cterm=none
hi CursorLine      ctermfg=none    ctermbg=none    cterm=none

if &background == "light"
hi LineNr          ctermfg=none    ctermbg=lightgray    cterm=none
else
hi LineNr          ctermfg=gray    ctermbg=black    cterm=none
endif

hi CursorLineNR    ctermfg=none    ctermbg=none    cterm=none

" -----------------
" - Number column -
" -----------------
hi CursorColumn    ctermfg=none    ctermbg=none    cterm=none
hi FoldColumn      ctermfg=none    ctermbg=none    cterm=none

if &background == "light"
hi SignColumn      ctermfg=none    ctermbg=lightgray cterm=none
else
hi SignColumn      ctermfg=gray    ctermbg=black    cterm=none
endif

hi Folded          ctermfg=none    ctermbg=none    cterm=none

" -------------------------
" - Window/Tab delimiters -
" -------------------------
hi VertSplit       ctermfg=none    ctermbg=black    cterm=none
hi ColorColumn     ctermfg=none    ctermbg=none    cterm=none
hi TabLine         ctermfg=none    ctermbg=none    cterm=none
hi TabLineFill     ctermfg=none    ctermbg=none    cterm=none
hi TabLineSel      ctermfg=none    ctermbg=none    cterm=none

" -----------------
" - Prompt/Status -
" -----------------
hi StatusLine      ctermfg=yellow    ctermbg=none    cterm=inverse
hi StatusLineNC    ctermfg=none    ctermbg=none    cterm=inverse
hi WildMenu        ctermfg=none    ctermbg=none    cterm=none
hi Question        ctermfg=none    ctermbg=none    cterm=none
hi Title           ctermfg=none    ctermbg=none    cterm=underline
hi ModeMsg         ctermfg=none    ctermbg=none    cterm=none
hi MoreMsg         ctermfg=none    ctermbg=none    cterm=none

" --------------
" - Visual aid -
" --------------
hi MatchParen      ctermfg=none    ctermbg=lightred cterm=none
hi Visual          ctermfg=none    ctermbg=none    cterm=inverse
hi VisualNOS       ctermfg=none    ctermbg=none    cterm=none
hi NonText         ctermfg=none    ctermbg=none    cterm=none

hi Underlined      ctermfg=none    ctermbg=none    cterm=underline
if &background == "light"
hi Error           ctermfg=none    ctermbg=lightred cterm=none " used in linters
hi Todo            ctermfg=none    ctermbg=lightyellow cterm=none
else
hi Error           ctermfg=black    ctermbg=red cterm=none " used in linters
hi Todo            ctermfg=black    ctermbg=darkyellow cterm=none
endif
hi ErrorMsg        ctermfg=none    ctermbg=none    cterm=none
hi WarningMsg      ctermfg=none    ctermbg=none    cterm=none
hi Ignore          ctermfg=none    ctermbg=none    cterm=none
hi SpecialKey      ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Variable types
" --------------------------------
hi Constant        ctermfg=none    ctermbg=none    cterm=none
hi String          ctermfg=none    ctermbg=none    cterm=none
hi StringDelimiter ctermfg=none    ctermbg=none    cterm=none
hi Character       ctermfg=none    ctermbg=none    cterm=none
hi Number          ctermfg=none    ctermbg=none    cterm=none
hi Boolean         ctermfg=none    ctermbg=none    cterm=none
hi Float           ctermfg=none    ctermbg=none    cterm=none

hi Identifier      ctermfg=none    ctermbg=none    cterm=none
if &background == "light"
hi Function        ctermfg=black ctermbg=none      cterm=italic
else
hi Function        ctermfg=magenta ctermbg=none    cterm=none
endif

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       ctermfg=none    ctermbg=none    cterm=none
hi Conditional     ctermfg=none    ctermbg=none    cterm=none
hi Repeat          ctermfg=none    ctermbg=none    cterm=none
hi Label           ctermfg=none    ctermbg=none    cterm=none
hi Operator        ctermfg=none    ctermbg=none    cterm=none
hi Keyword         ctermfg=none    ctermbg=none    cterm=none
hi Exception       ctermfg=none    ctermbg=none    cterm=none
hi Comment         ctermfg=red    ctermbg=none    cterm=none

hi Special         ctermfg=none    ctermbg=none    cterm=none
hi SpecialChar     ctermfg=none    ctermbg=none    cterm=none
hi Tag             ctermfg=none    ctermbg=none    cterm=none
hi Delimiter       ctermfg=none    ctermbg=none    cterm=none
hi SpecialComment  ctermfg=none    ctermbg=none    cterm=none
hi Debug           ctermfg=none    ctermbg=none    cterm=none

" ----------
" - C like -
" ----------
hi PreProc         ctermfg=none    ctermbg=none    cterm=none
hi Include         ctermfg=none    ctermbg=none    cterm=none
hi Define          ctermfg=none    ctermbg=none    cterm=none
hi Macro           ctermfg=none    ctermbg=none    cterm=none
hi PreCondit       ctermfg=none    ctermbg=none    cterm=none

hi Type            ctermfg=none    ctermbg=none    cterm=none
hi StorageClass    ctermfg=none    ctermbg=none    cterm=none
hi Structure       ctermfg=none    ctermbg=none    cterm=none
hi Typedef         ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Diff
" --------------------------------
hi diffAdded         ctermfg=darkgreen    ctermbg=none    cterm=none
hi diffChanged      ctermfg=none    ctermbg=none    cterm=none
hi diffRemoved      ctermfg=darkred    ctermbg=none    cterm=none
hi diffLine        ctermfg=darkcyan    ctermbg=none    cterm=none

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu           ctermfg=none    ctermbg=none    cterm=inverse
hi PmenuSel        ctermfg=none    ctermbg=none    cterm=none
hi PmenuSbar       ctermfg=none    ctermbg=none    cterm=none
hi PmenuThumb      ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Spelling
" --------------------------------
if &background == "light"
hi SpellBad cterm=underline ctermfg=lightblue ctermbg=none
hi SpellCap cterm=underline ctermfg=lightblue ctermbg=none
hi SpellLocal cterm=underline ctermfg=lightblue ctermbg=none
hi SpellRare cterm=underline ctermfg=lightblue ctermbg=none
else
hi SpellBad cterm=underline ctermfg=lightgreen ctermbg=none
hi SpellCap cterm=underline ctermfg=lightgreen ctermbg=none
hi SpellLocal cterm=underline ctermfg=lightgreen ctermbg=none
hi SpellRare cterm=underline ctermfg=lightgreen ctermbg=none
endif

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       ctermfg=none    ctermbg=none    cterm=none
hi Search          ctermfg=lightgray    ctermbg=yellow    cterm=none
hi IncSearch       ctermfg=lightgray    ctermbg=darkyellow    cterm=none

"--------------------------------------------------------------------
" Specific settings                                                 |
"--------------------------------------------------------------------
"
hi rustCommentLineDoc   ctermfg=red    ctermbg=none    cterm=none
hi link rustFuncCall    XNONE
hi link xmlTagName      XNONE
hi link xmlTag          XNONE

" This eliminates highlighting for some Python bits.
hi link pythonDecoratorName  XNONE
hi link pythonBuiltin        XNONE

" CTRL-SF plugin
hi link ctrlsfMatch Pmenu
