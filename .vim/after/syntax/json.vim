syn clear

syn match jsonKey "\".\{-}\""
hi! def link jsonKey Constant
