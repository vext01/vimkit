syn clear

syn match cComment1   "//.*$"
hi! def link cComment1 Comment

" Won't deal with nested comments, but meh
syn region cComment2 start="/\*" end="\*/"
hi! def link cComment2 Comment

syn match cPreProc "^\s*#.*$"
hi! def link cPreProc Constant

syn match cInclude "^\s*#.*include.*$"
hi! def link cInclude PreCondit
