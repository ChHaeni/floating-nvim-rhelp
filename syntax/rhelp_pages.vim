" Vim syntax file
" Language: R help pages
" Maintainer: Christoph Häni
" Latest Revision: 16 Nov 2022

""" includes
syn include @R $VIMRUNTIME/syntax/r.vim

""" block header (first few lines)
syn region rhelpHeader start="^\(\w\|[.]\)\+.*R Documentation$" end="^\zeDescription:\s*$" transparent contains=rhelpFirstLine,rhelpTitle
" third line (must be before highlighting of first line, such that first line
" takes preceedence & "overdraws")
syn match rhelpTitle '^\S\+.*$' contained containedin=rhelpHeader
" first line
syn match rhelpFirstLine '^\(\w\|[.]\)\+.*R Documentation$' contained contains=rhelpHeadFunction,rhelpHeadPackage,rhelpHeadDocu
syn match rhelpHeadFunction '^\(\w\|[.]\)\+' contained
syn match rhelpHeadPackage 'package:\zs\w\(\w\|[.]\)\+' contained
syn match rhelpHeadDocu 'R Documentation$' contained

""" block section (Description, etc.)
syn region rhelpSection start="^[A-Z]\(\S\+\s\?\)\+:\s*$" end="^\ze[A-Z]\(\S\+\s\?\)\+:\s*$" transparent contains=rhelpSectTitle,rhelpCode
syn match rhelpSectTitle '^[A-Z]\(\S\+\s\?\)\+:\s*$' contained
syn region rhelpCode start="[\u2018]\zs" end="\ze[\u2019]"

""" block Usage:
syn region rhelpUsage start='^Usage:\s*$' end='^\ze[A-Z]\(\S\+\s\?\)\+:\s*$' transparent contains=rhelpSectTitle,@R

""" block Examples:
syn region rhelpExamples start='^Examples:\s*$' end='^\zeArguments:\s*$' transparent keepend contains=rhelpSectTitle,@R

""" block Arguments: and Value:
" TODO: end -> include empty line before next argument!
syn region rhelpArgs start='^\(Arguments\|Value\):\s*$' end="^\ze\([A-Z]\w\+\s\?\)\+:\s*$" transparent contains=rhelpSectTitle,rhelpKeywords,rhelpCode
syn match rhelpKeywords '^\s*\(\([,]\s\)\?\(\w\|[.]\)\)\+:\ze\s\+\S' transparent contained contains=rhelpKeyword,rhelpPunct
syn match rhelpKeyword '\(\w\|[.]\)\+' contained
syn match rhelpPunct '\([,]\|[:]\)' contained

""" highlight colors
" hi GruvboxOrange guifg='#fe8019' ctermfg=208 guibg='NONE' ctermbg='NONE'
" hi GruvboxRed guifg='#fb4934' ctermfg=167 guibg='NONE' ctermbg='NONE'
" hi GruvboxBlue guifg='#83a598' ctermfg=109 guibg='NONE' ctermbg='NONE'
" hi GruvboxOrangeBold guifg='#fe8019' ctermfg=208 guibg='NONE' ctermbg='NONE' gui='bold' cterm='bold'
" hi GruvboxBlueBold guifg='#83a598' ctermfg=109 guibg='NONE' ctermbg='NONE' gui='bold' cterm='bold'
" header
hi def link rhelpHeadFunction GruvboxOrangeBold
hi def link rhelpHeadPackage GruvboxOrangeBold
hi def link rhelpHeadDocu GruvboxOrangeBold
hi! link rhelpTitle GruvboxBlueBold
" section
hi def link rhelpSectTitle GruvboxOrangeBold
hi def link rhelpCode GruvboxBlue
hi def link rhelpKeyword GruvboxRed
hi def link rhelpPunct GruvboxOrange
		" :highlight Normal ctermfg=grey ctermbg=darkblue
" background
hi RhelpNormal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828

