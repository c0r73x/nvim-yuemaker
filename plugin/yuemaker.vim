
nnoremap <plug>(YueCompile) :<c-u>call yuemaker#compile(1)<cr>

command! -bang -nargs=0 YueCompile call yuemaker#compile(1)
command! -bang -nargs=1 Yue call yuemaker#execute(<q-args>)

" Compile every out-of-date yue file on the runtimepath when the plugin
" loads. Set g:yuemaker_compile_on_load = 0 to skip this (e.g. when the
" files are built some other way) and use :YueCompile instead.
if get(g:, 'yuemaker_compile_on_load', 1)
    call yuemaker#compile(0)
endif
