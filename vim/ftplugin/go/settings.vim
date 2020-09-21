" show tabs as 2 spaces
setlocal listchars+=tab:\ \ 

setlocal foldmethod=syntax

" import package under cursor
nnoremap <leader><leader>i "iyiw:GoImport <C-R>=@i<CR><CR>
