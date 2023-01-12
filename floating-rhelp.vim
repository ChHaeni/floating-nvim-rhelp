" https://www.statox.fr/posts/2021/03/breaking_habits_floating_window/
function! Rhelp(text, ...) abort

    " Create the scratch buffer displayed in the floating window
    let buf = nvim_create_buf(v:false, v:true)

    " Get the current UI
    let ui = nvim_list_uis()[0]

    " Define the size of the floating window
    let width = ui.width / 4 * 3
    let height = ui.height / 4 * 3

    " call R help
    if a:0 > 0
        let packages = '\"' .. a:1 .. '\"'
    else
        let packages = 'dir(.libPaths())'
    endif
    let cmd = 'Rscript -e "help(\"' .. a:text .. '\", ' .. packages .. ')" | sed "s/_\x08//g"'
    let helptext = systemlist(cmd)

    " check if multiple matches -> first line 'Help on topic ...'
    let filetype = ''
    if helptext[0] =~ "^Help on topic"
        let line = 3
        while v:true
            let sub = line - 2 .. ':' .. substitute(helptext[line], '^\s*', ' ', '')
            call nvim_buf_set_lines(buf, line - 3, -1, v:false, [sub])
            " add mapping to select line by number
            call nvim_buf_set_keymap(buf, 'n', string(line - 2), ':normal! ' .. string(line - 2) .. 'G<cr>', 
                \ {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
            let line = line + 1
            if helptext[line] =~ "^\s*$"
                break
            endif
        endwhile
        " add mapping to call <cr> with help & package
        call nvim_buf_set_keymap(buf, 'n', '<cr>', ':call GetPackage()<cr>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
        " set buffer variable
        call nvim_buf_set_var(buf, 'rhelp', a:text)
        " set filetype
        call nvim_buf_set_option(buf, 'filetype', 'rhelp_select')
    else
        " add all text (:h nvim_buf_set_lines())
        call nvim_buf_set_lines(buf, 0, -1, v:false, helptext)
        " set filetype
        call nvim_buf_set_option(buf, 'filetype', 'rhelp_pages')
        " add mapping to follow 'See Also'
        call nvim_buf_set_keymap(buf, 'n', '<cr>', 'yiw :close <bar> call Rhelp(@")<cr>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
        call nvim_buf_set_keymap(buf, 'n', 'K', 'yiw :close <bar> call Rhelp(@")<cr>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
        " add mapping to get back to 'overview'
        call nvim_buf_set_keymap(buf, 'n', '<c-^>', ':close <bar> call Rhelp("' .. a:text .. '")<cr>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
    endif

    " Set mappings in the buffer to close the window easily
    " let closingKeys = ['<Esc>', '<CR>', '<Leader>']
    let closingKeys = ['<Esc>', 'q']
    for closingKey in closingKeys
        call nvim_buf_set_keymap(buf, 'n', closingKey, ':close<CR>', {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
    endfor

    " Create the floating window
    " :h nvim_open_win()
    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': height,
                \ 'col': (ui.width/2) - (width/2),
                \ 'row': (ui.height/2) - (height/2),
                \ 'anchor': 'NW',
                \ 'border': 'single',
                \ }
    " create window
    let win = nvim_open_win(buf, 1, opts)
    " redefine keyword (e.g. for yiw)
    call win_execute(win, 'setlocal iskeyword=@,48-57,_,.')
    " set modifiable off
    call nvim_buf_set_option(0, 'modifiable', v:false)
endfunction

function! GetPackage() abort
    let line = getline('.')
    let package = substitute(line, '^\v\d+:\s+(\w(\w|[.])+)\s+.*', '\1', '')
    " close current buffer and call Rhelp with package
    let rhelp = b:rhelp
    close
    call Rhelp(rhelp, package)
endfunction
