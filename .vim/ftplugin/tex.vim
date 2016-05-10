syntax spell toplevel
syntax on
set spell
set noai nocin nosi inde=
set shiftwidth=4
set tabstop=4
set expandtab

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

hi SpellBad cterm=underline ctermfg=magenta ctermbg=none
hi SpellCap cterm=underline ctermfg=magenta ctermbg=none
hi SpellLocal cterm=underline ctermfg=magenta ctermbg=none
hi SpellRare cterm=underline ctermfg=magenta ctermbg=none
setlocal spell spelllang=en_gb
set spell
