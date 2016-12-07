syn clear

syn match makeComment   "#.*$"
hi! def link makeComment Comment

syn match makeTarget "^[a-zA-Z-_]*:"
hi! def link makeTarget PreCondit
