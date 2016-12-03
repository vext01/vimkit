"syntax on
"syn clear
"syn match   pythonComment	"#.*$" contains=pythonTodo,@Spell
"syn keyword pythonTodo		FIXME NOTE NOTES TODO XXX contained
"hi def link pythonComment		Comment
"hi Comment ctermfg=darkred

map <C-k> Oimport pdb; pdb.set_trace()<esc>
map <C-f> :call Flake8()<CR>
