set cinoptions=:0,t0,+4,(4

if exists("g:softdev")
    " OpenBSD KNF with tabs with 4 spaces
    set tabstop=4
    set expandtab
    set shiftwidth=4
else
    " OpenBSD KNF
    set tabstop=8
    set noexpandtab
    set shiftwidth=8
endif
