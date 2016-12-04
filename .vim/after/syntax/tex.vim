syn clear

" Stops e.g. \% becoming a comment
syn region Escape start=/\\/ end=/./ matchgroup=NONE

" Stops % in listings making comments
syn region LstListing start=/\\begin{lstlisting}/ end=/\\end{lstlisting}/ matchgroup=NONE

syn match texComment "%.*$"
hi! def link texComment Comment

syn match texSection "\\\(sub\)*section{.*}"
hi! def link texSection PreCondit

syn match texDocClass "\\documentclass.*{.*}"
hi! def link texDocClass PreCondit

syn match texRefer "\\\(label\|ref\){.*}"
hi! def link texRefer Constant

syn match texUsePackage "\\usepackage.*{.*}"
hi! def link texUsePackage Constant

syn match texEnvBound "\\\(begin\|end\){.*}\(\[.*\]\)\{0,1\}"
hi! def link texEnvBound Conditional
