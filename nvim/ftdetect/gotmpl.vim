augroup GOHTMLTMPL
autocmd BufNewFile,BufRead,BufWrite *.html if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl.html | endif
augroup END
