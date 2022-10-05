
function! yuemaker#compile(...)
    let verbose = len(a:000) == 0 ? 0 : a:1
    if verbose
        lua require("yuemaker").compileAll(true)
    else
        lua require("yuemaker").compileAll(false)
    endif
endfunction

function! yuemaker#execute(yueText)
    call luaeval("require('yuemaker').executeYue(_A)", a:yueText)
endfunction

function! yuemaker#compileyueIfOutOfDate(yuePath, luaPath)
    call luaeval("require('yuemaker').compileYueIfOutOfDate(_A[1], _A[2])", [a:yuePath, a:luaPath])
endfunction

nnoremap <plug>(YueCompile) :<c-u>call yuemaker#compile(1)<cr>

command! -bang -nargs=0 YueCompile call yuemaker#compile(1)
command! -bang -nargs=1 Yue call yuemaker#execute(<q-args>)

