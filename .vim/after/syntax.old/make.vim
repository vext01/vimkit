syn clear

syn match makeComment   "#.*$"
hi! def link makeComment Comment

syn match makeTarget "^\S\+:"
hi! def link makeTarget PreCondit
