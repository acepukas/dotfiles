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

" Obsession: tpope/vim-obsession
" load session if present
nnoremap <F2> :source Session.vim<CR>

" GUNDO: sjl/gundo.vim
nnoremap <F5> :GundoToggle<CR>
let g:gundo_preview_bottom = 1

" ALE: w0rp/ale
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1

let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'json': ['jsonlint'],
      \ 'pug': ['puglint'],
      \ 'cpp': []
      \ }

let g:ale_sign_column_always = 1
let g:ale_sign_error = '✘✘'
let g:ale_sign_warning = '⚠⚠'
let g:ale_statusline_format = ['✘ %d', '⚠ %d', '']

nnoremap <silent> [r :exe "normal \<Plug>(ale_previous_wrap)"<CR>
nnoremap <silent> ]r :exe "normal \<Plug>(ale_next_wrap)"<CR>

augroup AutoALE
  autocmd!
  autocmd User ALELint call s:updateLightLine()
augroup END

function! s:updateLightLine() abort
  call lightline#update()
endfunction

" GitGutter: airblade/vim-gitgutter
let g:gitgutter_sign_added = ' +'
let g:gitgutter_sign_modified = ' ~'
let g:gitgutter_sign_removed = ' −'
let g:gitgutter_sign_removed_first_line = ' ‾'
let g:gitgutter_sign_modified_removed = ' ≃'

" TernJS: marijnh/tern_for_vim
let tern#is_show_argument_hints_enabled = 'true'
let g:my_tern_path = expand('<sfile>:h') . '/.vim/plugged/tern_for_vim/node_modules/tern/bin/tern'
let g:tern#command = ["node", g:my_tern_path, '--no-port-file', '--persistent']
let g:tern_request_timeout = 3

" YCM: Valloric/YouCompleteMe
let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>'] 
let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>'] 

" let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_add_preview_to_completeopt = 0
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview

let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/.ycm_extra_conf.py'

let g:ycm_filetype_blacklist = {
  \ 'vim': 1
  \}

" SuperTab: ervandew/supertab
let g:SuperTabDefaultCompletionType = '<TAB>'

" UltiSnips: SirVer/ultisnips
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetsDir=$HOME . '/.vim/UltiSnips'
let g:UltiSnipsSnippetDirectories=['UltiSnips']

let g:UltiSnipsExpandTrigger='<c-z>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsListSnippets='<c-b>'

" VimQf: romainl/vim-qf
nnoremap <silent> <C-Q> :exe "normal \<Plug>QfSwitch"<CR>
let g:qf_mapping_ack_style = 1

" FZFVIM: junegunn/fzf.vim
nnoremap <C-P> :FZF<CR>
nnoremap <leader><tab> :Buffers<CR>

" case sensitive rg command
nnoremap <leader>q :RGS 

let g:rg_command = $RG_COMMAND_BASE . ' --column --line-number --no-heading --color "always"'

fun! BuildRgCommand(opts, qargs)
  let l:list = [g:rg_command] + a:opts + ['--', shellescape(a:qargs)]
  return join(l:list, ' ')
endfun

" Search recursive ignoring case
command! -bang -nargs=* RG call fzf#vim#grep(BuildRgCommand(['--ignore-case', '--fixed-strings'], <q-args>), 1, <bang>0)

" Search recursive case sensitive
command! -bang -nargs=* RGS call fzf#vim#grep(BuildRgCommand(['--fixed-strings'], <q-args>), 1, <bang>0)

" Search recursive case sensitive as RegExp
command! -bang -nargs=* RGX call fzf#vim#grep(BuildRgCommand([], <q-args>), 1, <bang>0)

" Seach recursive case sensitive with word boundaries
command! -bang -nargs=* RGSW call fzf#vim#grep(BuildRgCommand(['-w', '--fixed-strings'], <q-args>), 1, <bang>0)

" Search files for word under cursor
nnoremap <leader>s "zyiw :exe ':RGSW ' . @z<cr>

" Search files for visually selected text
vnoremap <leader>s "zy :exe ':RGS ' . @z<cr>

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
nnoremap <F7> :TagbarToggle<CR>
let g:tagbar_width = 50

" Tag Highlight: vim-scripts/TagHighlight
" let g:TagHighlightSettings = { }
" let g:TagHighlightSettings['ExtensionLanguageOverrides'] = {'inl': 'c'}

" Vim Easy Align: junegunn/vim-easy-align
vnoremap <silent> <Enter> :EasyAlign<CR>

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
nmap <silent> <C-f> :exe "normal \<Plug>(jsdoc)"<CR>
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1

" Vim Go: fatih/vim-go
let g:go_disable_autoinstall = 0

" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

" go syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

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

" restore previous line continuation settings
let &cpo = s:cpo_save