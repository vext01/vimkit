syn region Comment start=/"""/ end=/"""/

map <C-k> Oimport pdb; pdb.set_trace()<esc>

map <C-f> :call Flake8()<CR>
