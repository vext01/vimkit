syn clear

syn region gitFirstLine  start="\%^[^#]" end="\n"
hi! def link gitFirstLine PreCondit

syn match gitComment   "^#.*$"
hi! def link gitComment Comment

