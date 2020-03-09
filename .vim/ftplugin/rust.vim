set colorcolumn=99

" RLS for Rust isn't yet portable (not available on OpenBSD right now).
let uname = substitute(system('uname'), '\n', '', '')
if 'uname' == 'Linux'
    nmap gd :ALEGoToDefinition<cr>
endif
