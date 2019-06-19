if exists("g:loaded_plugin_config") || &cp
  finish
endif
let g:loaded_plugin_config=1

" save line continuation setting and restore it after script is loaded
" This is so that line continuation is supported
let s:cpo_save = &cpo
set cpo&vim

" NERDTree: scrooloose/nerdtree
nnoremap <F1> :NERDTreeToggle<CR>

" AutoPairs: jiangmiao/auto-pairs
let g:AutoPairsMultilineClose = 0

let g:AutoPairsMapCh = 0
let g:AutoPairsCenterLine = 0
let g:AutoPairsShortcutToggle = '<F6>'

" Obsession: tpope/vim-obsession
" load session if present
nnoremap <F3> :source Session.vim<CR>

" GUNDO: sjl/gundo.vim
nnoremap <F5> :GundoToggle<CR>
let g:gundo_preview_bottom = 1

" ALE: w0rp/ale
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1

let g:gometalinter_options = [
  \ ['exclude', 'error return value not checked.*(Close|Log|Print).*\(errcheck\)$'],
  \ ['exclude', '.*_test\.go:.*error return value not checked.*\(errcheck\)$'],
  \ ['exclude', 'duplicate of.*_test.go.*\(dupl\)$'],
  \ ['disable', 'aligncheck'],
  \ ['disable', 'gotype'],
  \ ['disable', 'gas'],
  \ ['cyclo-over', '20'],
  \ 'tests',
  \ ['deadline', '20s']
  \ ]

fun! s:BuildGoMetalinterOptionsStr() abort
  let l:optStrs = []
  for opt in g:gometalinter_options
    if type(opt) == type([])
      let l:optStr = '--' . opt[0]
      if opt[1] =~ '\s'
        let l:optStr = l:optStr . "='" . opt[1] . "'"
      else
        let l:optStr = l:optStr . '=' . opt[1]
      endif
      let l:optStrs = add(l:optStrs, l:optStr)
    elseif type(opt) == type('')
      let l:optStrs = add(l:optStrs, '--' . opt)
    endif
  endfor
  return join(l:optStrs, ' ')
endf


let g:ale_go_gometalinter_options = s:BuildGoMetalinterOptionsStr()

let g:ale_c_build_dir='build'

let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'json': ['jsonlint'],
      \ 'pug': ['puglint'],
      \ 'cpp': ['clang'],
      \ 'go': ['gometalinter'],
      \ 'haskell': ['ghc-mod', 'hlint']
      \ }

let g:ale_sign_column_always = 1
let g:ale_sign_error = '✘✘'
let g:ale_sign_warning = ''
let g:ale_statusline_format = ['✘ %d', ' %d', '']

nnoremap <silent> [r :exe "normal \<Plug>(ale_previous_wrap)"<CR>
nnoremap <silent> ]r :exe "normal \<Plug>(ale_next_wrap)"<CR>

" GitGutter: airblade/vim-gitgutter
let g:gitgutter_sign_added = ' +'
let g:gitgutter_sign_modified = ' ~'
let g:gitgutter_sign_removed = ' −'
let g:gitgutter_sign_removed_first_line = ' ‾'
let g:gitgutter_sign_modified_removed = ' ≃'

" YCM: Valloric/YouCompleteMe
let g:ycm_key_list_select_completion = ['<C-j>', '<C-n>', '<Down>'] 
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>'] 

" let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1

" turn off YCM error reporting
let g:ycm_show_diagnostics_ui = 0
let g:ycm_max_diagnostics_to_display = 0

let g:ycm_add_preview_to_completeopt = 0
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview

let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/.ycm_extra_conf.py'

let g:ycm_filetype_blacklist = {
  \ 'vim': 1
  \}

let g:ycm_semantic_triggers = {
      \ 'elm' : ['.'],
      \ }

" SuperTab: ervandew/supertab
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:SuperTabCrMapping = 0

" UltiSnips: SirVer/ultisnips
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetsDir=$HOME . '/.vim/UltiSnips'
let g:UltiSnipsSnippetDirectories=['UltiSnips']

let g:UltiSnipsExpandTrigger='<c-z>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsListSnippets='<c-b>'

let g:snips_author = 'Aaron Cepukas'
let g:snips_email = 'acepukas@gmail.com'
let g:snips_github = 'https://github.com/acepukas'

" VimQf: romainl/vim-qf
nnoremap <silent> <C-Q> :exe "normal \<Plug>QfSwitch"<CR>
let g:qf_mapping_ack_style = 1

" FZFVIM: junegunn/fzf.vim
nnoremap <silent> <C-P> :Files<CR>
nnoremap <leader><tab> :Buffers<CR>

" case sensitive rg command
nnoremap <leader>q :RGS 

let g:rg_command = $RG_COMMAND_BASE . ' --column --line-number --no-heading --color "always"'

fun! BuildRgCommand(opts, qargs)
  let l:list = [g:rg_command] + a:opts + ['--', shellescape(a:qargs)]
  return join(l:list, ' ')
endfun

command! -nargs=? -complete=file Files call Fzf_dev(<q-args>)

" Files + dev icons
function! Fzf_dev(qargs)

  let l:fzf_files_options = '--expect=ctrl-t,ctrl-v,ctrl-x --preview "bat --theme=gruvbox --style=numbers,changes --color always {2..-1} | head -'.&lines.'" --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all --ansi'

  function! s:files(dir)
    let l:cmd = g:rg_command . ' --files'
    if a:dir != ''
      let l:cmd .= ' ' . shellescape(a:dir)
    endif
    return s:prepend_icon(systemlist(l:cmd))
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []

    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(lines)
    if len(a:lines) < 2 | return | endif

    let l:cmd = get({'ctrl-x': 'split',
                 \ 'ctrl-v': 'vertical split',
                 \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
    for l:item in a:lines[1:]
      let l:pos = stridx(l:item, ' ')
      let l:file_path = l:item[pos+1:-1]
      execute 'silent '. l:cmd . ' ' . l:file_path
    endfor
  endfunction

  call fzf#run(fzf#wrap('with-preview', {
        \ 'source': <sid>files(a:qargs),
        \ 'sink*': function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down': '40%' }, 0))

endfunction

" Search recursive ignoring case
command! -bang -nargs=* RG call fzf#vim#grep(BuildRgCommand(['--ignore-case', '--fixed-strings'], <q-args>), 1, <bang>0)

" Search recursive case sensitive
command! -bang -nargs=* RGS call fzf#vim#grep(BuildRgCommand(['--fixed-strings'], <q-args>), 1, <bang>0)

" Search recursive case sensitive as RegExp
command! -bang -nargs=* RGX call fzf#vim#grep(BuildRgCommand([], <q-args>), 1, <bang>0)

" Seach recursive case sensitive with word boundaries
command! -bang -nargs=* RGSW call fzf#vim#grep(BuildRgCommand(['-w', '--fixed-strings'], <q-args>), 1, <bang>0)

" Search files for word under cursor
nnoremap <leader>* "zyiw :let cmd = 'RGSW ' . @z <bar> call histadd("cmd", cmd) <bar> execute cmd<cr>

" Search files for visually selected text
xnoremap <leader>* "zy :let cmd = 'RGS ' . @z <bar> call histadd("cmd", cmd) <bar> execute cmd <cr>

" Populate quickfix window with selected fzf pane contents

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" TagBar: majutsushi/tagbar
nnoremap <F2> :TagbarToggle<CR>
let g:tagbar_width = 50

" Tag Highlight: vim-scripts/TagHighlight
" let g:TagHighlightSettings = { }
" let g:TagHighlightSettings['ExtensionLanguageOverrides'] = {'inl': 'c'}

" Vim Easy Align: junegunn/vim-easy-align
xnoremap <silent> <Enter> :EasyAlign<CR>

if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif

" Custom alignment delimeters for c style langs
let g:easy_align_delimiters['d'] = {
\ 'pattern': ' \(\S\+\s*[;=]\)\@=',
\ 'left_margin': 0, 'right_margin': 0
\ }

" Easy Motion: Lokaltog/vim-easymotion
hi link EasyMotionTarget2First Constant
hi link EasyMotionTarget2Second Constant

" Vim Flow: flowtype/vim-flow
" disabling system wide. Enable with dir level .vimrc if needed
let g:flow#enable = 0
let g:flow#omnifunc = 0

" Vim JavaScript: pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1

" Vim JsDoc: heavenshell/vim-jsdoc
nmap <silent> <leader>j :exe "normal \<Plug>(jsdoc)"<CR>
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1

" Vim Go: fatih/vim-go

" prevent automatic installation of all vim-go dependencies
let g:go_disable_autoinstall = 0

" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

" go syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1

" camel case for JSON tags
let g:go_addtags_transform = "camelcase"

let g:go_fold_enable = ['import', 'package_comment']

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

augroup GOHTMLTMPL
  au BufRead,BufNewFile *.tmpl set filetype=gohtmltmpl.html
augroup END

" NERDCommenter: scrooloose/nerdcommenter
let g:NERDSpaceDelims = 1

" handle vue component file commenting
let g:NERD_ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:NERD_ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:NERD_ft == 'vue'
    setf vue
    let g:NERD_ft = ''
  endif
endfunction

" restore previous line continuation settings
let &cpo = s:cpo_save

" ElmVim: ElmCast/elm-vim
let g:elm_setup_keybindings = 0

" color_coded
hi! link Member GruvboxAquaBold
hi! link Variable GruvboxFg3
hi! link EnumConstant GruvboxBlue
