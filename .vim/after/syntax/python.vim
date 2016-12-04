syn clear

syn match pythonComment   "#.*$"
hi! def link pythonComment Comment

syn match pythonFunction "^\s*def"
hi! def link pythonFunction PreCondit

syn match pythonClass "^\s*class"
hi! def link pythonClass PreCondit

syn region pythonTriples1 start=/"""/ end=/"""/
syn region pythonTriples2 start=/"""/ end=/"""/
hi! def link pythonTriples1 Constant
hi! def link pythonTriples2 Constant

syn match pythonImport1 "[\s]*import.*$"
syn match pythonImport2 "[\s]*from.*import.*$"
syn region pythonImport3 start="[\s]*from.*import.* (.*" end=")"
hi! def link pythonImport1 Function
hi! def link pythonImport2 Function
hi! def link pythonImport3 Function
