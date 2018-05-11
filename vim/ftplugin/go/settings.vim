" show tabs as 2 spaces
setlocal listchars+=tab:\ \ 

setlocal foldmethod=syntax

" normal mode mapping for displaying information about element under cursor
nnoremap <leader>i :GoInfo<CR>

" import package under cursor
nnoremap <leader><leader>i "iyiw:GoImport <C-R>=@i<CR><CR>
