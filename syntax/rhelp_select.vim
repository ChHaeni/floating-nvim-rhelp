" Vim syntax file
" Language: R help package selection
" Maintainer: Christoph Häni
" Latest Revision: 16 Nov 2022

syn match rhs_num '^\d\+:'
syn match rhs_package '\s\+\zs\w\(\w\|[.]\)*' contains=rhs_base
syn keyword rhs_base base stats graphics grDevices utils datasets methods contained
syn match rhs_path '\s\+\zs\S\+\s*$'

""" highlight colors
" hi GruvboxBlue guifg='#83a598' ctermfg=109 guibg='NONE' ctermbg='NONE'
" hi GruvboxOrangeBold guifg='#fe8019' ctermfg=208 guibg='NONE' ctermbg='NONE' gui='bold' cterm='bold'
" hi GruvboxAquaBold guifg='#8ec07c' ctermfg=108 guibg='NONE' ctermbg='NONE' gui='bold' cterm='bold'
hi def link rhs_num GruvboxBlue
hi def link rhs_package GruvboxOrangeBold
hi def link rhs_base GruvboxAquaBold
hi def link rhs_path GruvboxBlue
