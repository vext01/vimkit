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
