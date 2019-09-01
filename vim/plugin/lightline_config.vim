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
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'method' ] ],
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
      \   'obsession': 'MyObsession',
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" lightline-ale ale and coc.nvim integration

let g:lightline.active.right =
      \ [['linter_errors', 'linter_warnings', 'linter_ok']] +
      \ g:lightline.active.right

let g:lightline.component_expand = {
  \ 'linter_errors': 'StatusErrors',
  \ 'linter_warnings': 'StatusWarnings',
  \ 'linter_ok': 'StatusOK'
  \ }

let g:lightline.component_type = {
  \ 'linter_warnings': 'warning',
  \ 'linter_errors': 'error'
  \ }

let g:lightline#ale#indicator_warnings = ''

let g:lightline#ale#indicator_errors = '✘'

let g:lightline#ale#indicator_ok = '✔'

" lightline component functions

function! s:is_tmp_file() abort
  if !empty(&buftype) | return 1 | endif
  if index(['startify', 'gitcommit'], &filetype) > -1 | return 1 | endif
  if expand('%:p') =~# '^/tmp' | return 1 | endif
endfunction

function! StatusOK() abort
  if s:is_tmp_file() | return '' | endif
  if get(g:, 'coc_enabled', 0)
    let info = get(b:, 'coc_diagnostic_info', {})
    if !empty(info) && empty(info['error']) && empty(info['warning'])
      return g:lightline#ale#indicator_ok
    else
      return ''
    endif
  elseif get(b:, 'ale_enabled', 0)
    return lightline#ale#ok()
  endif
  return ''
endfunction

function! StatusErrors() abort
  if s:is_tmp_file() | return '' | endif
  if get(g:, 'coc_enabled', 0)
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    if empty(info['error']) | return '' | endif
    let msgs = []
    if get(info, 'error', 0)
      call add(msgs, g:lightline#ale#indicator_errors . ' ' . info['error'])
    endif
    return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
  elseif get(b:, 'ale_enabled', 0)
    return lightline#ale#errors()
  endif
  return ''
endfunction

function! StatusWarnings() abort
  if s:is_tmp_file() | return '' | endif
  if get(g:, 'coc_enabled', 0)
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    if empty(info['warning']) | return '' | endif
    let msgs = []
    if get(info, 'warning', 0)
      call add(msgs, g:lightline#ale#indicator_warnings . ' ' . info['warning'])
    endif
    return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
  elseif get(b:, 'ale_enabled', 0)
    return lightline#ale#warnings()
  endif
  return ''
endfunction

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! NearestMethodOrFunction() abort
  let l:fn = get(b:, 'vista_nearest_method_or_function', '')
  if l:fn != ''
    return '🝡 ' . l:fn
  endif
  return ''
endfunction

autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

function! MyModified()
  return &ft =~ 'Tagbar\|help\|vimfiler\|mundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'Tagbar\|help\|vimfiler\|mundo' && &readonly ? '' : ''
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

  return fname =~ '__Mundo\|NERD_tree' ? '' :
        \ fname == '__Tagbar__.1' ? g:lightline.fname :
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
        \  &ft == 'unite' ? unite#get_status_string() : 
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != fname ? fpath : '[No Name]') .
        \ ('' != MyReadonly() ? ' ' . MyReadonly() . ' ' : '') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'Tagbar\|vimfiler\|Mundo\|NERD' && exists("*fugitive#head")
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
        \ fname == '__Mundo__' ? 'Mundo' :
        \ fname == '__Mundo_Preview__' ? 'Mundo Preview' :
        \ fname == '__Tagbar__.1' ? 'Tagbar' :
        \ fname == '__vista__' ? 'Vista' :
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
