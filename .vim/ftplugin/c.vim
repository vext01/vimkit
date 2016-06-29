set cinoptions=:0,t0,+4,(4

" OpenBSD KNF
"set tabstop=8
"set noexpandtab
"set shiftwidth=8

" Soft-dev (KNF with no tabs)
set tabstop=4
set expandtab
set shiftwidth=4

:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
