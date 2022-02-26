
if exists("g:loaded_sygroup_plugin") || &cp
  finish
endif
let g:loaded_sygroup_plugin=1

function! SyntaxInfoFn() abort
  echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction

" display syntax information about element under cursor
command! -bang -nargs=0 SyntaxInfo :call SyntaxInfoFn()
