
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
