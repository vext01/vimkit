"set shiftwidth=4
"set tabstop=4
"set expandtab
syn region Comment start=/"""/ end=/"""/

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

map <C-k> Oimport pdb; pdb.set_trace()<esc>

map <C-f> :call Flake8()<CR>
