if exists("g:loaded_lightline_config") || &cp
  finish
endif
let g:loaded_lightline_config=1

" save line continuation setting and restore it after script is loaded
" This is so that line continuation is supported
let s:cpo_save = &cpo
set cpo&vim

" lightline needs status line visible
set laststatus=2

let g:lightline = {
      \ 'enable': {
      \   'tabline': 1
      \ },
      \ 'colorscheme': 'gruvbox',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
      \   'right': [ [ 'percent', 'lineinfo' ],
      \              [ 'obsession', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'obsession': 'MyObsession'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" lightline-ale ale integration

let g:lightline.active.right =
      \ [['linter_errors', 'linter_warnings', 'linter_ok']] +
      \ g:lightline.active.right

let g:lightline.component_expand = {
  \ 'linter_warnings': 'lightline#ale#warnings',
  \ 'linter_errors': 'lightline#ale#errors',
  \ 'linter_ok': 'lightline#ale#ok'
  \ }

let g:lightline.component_type = {
  \ 'linter_warnings': 'warning',
  \ 'linter_errors': 'error'
  \ }

let g:lightline#ale#indicator_warnings = ''

let g:lightline#ale#indicator_errors = '✘'

let g:lightline#ale#indicator_ok = '✔'

" lightline component functions

function! MyModified()
  return &ft =~ 'Tagbar\|help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'Tagbar\|help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! MyFilename()
  " filename used for tests against various file types
  let fname = expand('%:t')

  " when displaying path of file, show path relative to current working
  " directory. Has the added benefit of showing the full path of any files
  " loaded outside of the current working directoy.
  let curdir = substitute(fnamemodify(getcwd(),':p'),"\\/","\\\\/","g")
  let fpath = expand('%:p')
  let fpath = substitute(fpath,curdir,"","g")

  return fname =~ '__Gundo\|NERD_tree' ? '' :
        \ fname == '__Tagbar__.1' ? g:lightline.fname :
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
        \  &ft == 'unite' ? unite#get_status_string() : 
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != fname ? fpath : '[No Name]') .
        \ ('' != MyReadonly() ? ' ' . MyReadonly() . ' ' : '') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'Tagbar\|vimfiler\|Gundo\|NERD' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == 'ControlP' ? 'CtrlP' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname == '__Tagbar__.1' ? 'Tagbar' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyObsession()
  if exists("*ObsessionStatus")
    return ObsessionStatus('●', '○')
  endif
  return ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
  let l:flagstr = join(a:flags, '')
  if l:flagstr != ''
      let l:flagstr = '[' . l:flagstr . '] '
  endif
  let l:status = '[s:' . a:sort . '] ' . l:flagstr . a:fname
  let g:lightline.fname = l:status
  return lightline#statusline(0)
endfunction

" restore previous line continuation settings
let &cpo = s:cpo_save
