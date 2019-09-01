" Fold Settings {{{
" vim:foldmarker={{{,}}}:foldmethod=marker
" }}}
" plugin setup {{{
if exists("g:loaded_plugin_config") || &cp
  finish
endif
let g:loaded_plugin_config=1

" save line continuation setting and restore it after script is loaded
" This is so that line continuation is supported
let s:cpo_save = &cpo
set cpo&vim
" }}}
" NERDTree: scrooloose/nerdtree {{{
nnoremap <F1> :NERDTreeToggle<CR>
" }}}
" AutoPairs: jiangmiao/auto-pairs {{{
let g:AutoPairsMultilineClose = 0

let g:AutoPairsMapCh = 0
let g:AutoPairsCenterLine = 0
let g:AutoPairsShortcutToggle = '<F6>'
" }}}
" Obsession: tpope/vim-obsession {{{
" load session if present
nnoremap <F3> :source Session.vim<CR>
" }}}
" MUNDO: simnalamburt/vim-mundo {{{
nnoremap <F5> :MundoToggle<CR>
let g:mundo_preview_bottom = 1
" }}}
" ALE: w0rp/ale {{{
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

let g:ale_pattern_options = {
\   '\.go$': {
\       'ale_linters': [],
\       'ale_fixers': [],
\       'ale_enabled': 0
\   },
\}

let g:ale_c_build_dir='build'

let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'json': ['jsonlint'],
      \ 'pug': ['puglint'],
      \ 'cpp': ['clang'],
      \ 'go': [],
      \ 'haskell': ['ghc-mod', 'hlint']
      \ }

let g:ale_sign_column_always = 1
let g:ale_sign_error = '✘✘'
let g:ale_sign_warning = ''
let g:ale_statusline_format = ['✘ %d', ' %d', '']

" nnoremap <silent> [r :exe "normal \<Plug>(ale_previous_wrap)"<CR>
" nnoremap <silent> ]r :exe "normal \<Plug>(ale_next_wrap)"<CR>
" }}}
" GitGutter: airblade/vim-gitgutter {{{
let g:gitgutter_sign_added = ' +'
let g:gitgutter_sign_modified = ' ~'
let g:gitgutter_sign_removed = ' −'
let g:gitgutter_sign_removed_first_line = ' ‾'
let g:gitgutter_sign_modified_removed = ' ≃'
" }}}
" UltiSnips: SirVer/ultisnips {{{
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetsDir=$HOME . '/.vim/my_snippets'
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'my_snippets']

let g:UltiSnipsExpandTrigger='<c-z>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsListSnippets='<c-b>'

let g:snips_author = 'Aaron Cepukas'
let g:snips_email = 'acepukas@gmail.com'
let g:snips_github = 'https://github.com/acepukas'
" }}}
" VimQf: romainl/vim-qf {{{
nnoremap <silent> <C-Q> :exe "normal \<Plug>QfSwitch"<CR>
let g:qf_mapping_ack_style = 1
" }}}
" FZFVIM: junegunn/fzf.vim {{{
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

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" }}}
" Vim Easy Align: junegunn/vim-easy-align {{{
xnoremap <silent> <Enter> :EasyAlign<CR>

if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif

" Custom alignment delimeters for c style langs
let g:easy_align_delimiters['d'] = {
\ 'pattern': ' \(\S\+\s*[;=]\)\@=',
\ 'left_margin': 0, 'right_margin': 0
\ }
" }}}
" Easy Motion: Lokaltog/vim-easymotion {{{
hi link EasyMotionTarget2First Constant
hi link EasyMotionTarget2Second Constant
" }}}
" Vim JavaScript: pangloss/vim-javascript {{{
let g:javascript_plugin_jsdoc = 1
" }}}
" Vim JsDoc: heavenshell/vim-jsdoc {{{
nmap <silent> <leader>j :exe "normal \<Plug>(jsdoc)"<CR>
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1
" }}}
" Vim Go: fatih/vim-go {{{

" disable vim-go :GoDef short-cut (gd)
" Will be handled by Lang Server
let g:go_def_mapping_enabled = 0

let g:go_doc_keywordprg_enabled = 0

let g:go_metalinter_autosave = 0

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
" }}}
" NERDCommenter: scrooloose/nerdcommenter {{{
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
" }}}
" coc.nvim: neoclide/coc.nvim {{{

" if hidden is not set, TextEdit might fail.
set hidden

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.

inoremap <expr> <CR> InsertMapForEnter()
function! InsertMapForEnter()
  let l:nextChar = strcharpart(getline('.'),getpos('.')[2]-1,1)
  if pumvisible()
    return "\<C-y>"
  elseif l:nextChar == '}' || l:nextChar == ')' || l:nextChar == ']'
    return "\<CR>\<Esc>O"
  elseif strcharpart(getline('.'),getpos('.')[2]-1,2) == '</'
    return "\<CR>\<Esc>O"
  else
    return "\<C-g>u\<CR>"
  endif
endfunction


" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [r <Plug>(coc-diagnostic-prev)
nmap <silent> ]r <Plug>(coc-diagnostic-next)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>=  <Plug>(coc-format-selected)
nmap <leader>=  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <leader><space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader><space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader><space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader><space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader><space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader><space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader><space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader><space>p  :<C-u>CocListResume<CR>
" }}}
" vim.vista: liuchengxu/vista.vim {{{

let g:vista_default_executive = 'coc'
let g:vista_close_on_jump = 1

nnoremap <F2> :Vista<CR>
nnoremap <leader>p :Vista finder<CR>

let g:vista#renderer#icons = {
\    'subroutine': '',
\    'method': '⎔',
\    'func': '🝡',
\    'variables': '𝞌',
\    'namespace': '',
\    'field': '𝄩',
\    'interface': '◇',
\    'type': '',
\    'packages': '',
\    'property': '',
\    'implementation': '◈',
\    'default': '',
\    'augroup': '',
\    'macro': '',
\    'enumerator': '',
\    'const': '',
\    'macros': '',
\    'map': '',
\    'fields': '𝄩',
\    'functions': '🝡',
\    'enum': '',
\    'function': '🝡',
\    'target': '🞋',
\    'typedef': '⚒',
\    'variable': '𝞌',
\    'modules': '',
\    'constant': '',
\    'struct': '',
\    'types': '',
\    'module': '',
\    'typeParameter': '⚙',
\    'package': '',
\    'class': '',
\    'member': '',
\    'var': '𝞌',
\    'union': '⚭'
\    }
" }}}
