" -----------------------------------------------------------------------------
" Filename: autoload/lightline/colorscheme/gruvbox.vim
" Version: 0.1
" Author: Aaron Cepukas
" License: MIT License
" Last Change: 2015-06-20
" -----------------------------------------------------------------------------

let s:base03  = [ '#282828', 235 ] " mode label dark
let s:base023 = [ '#383432', 237 ] " inactive bar background
let s:base02  = [ '#3c3836', 239 ] " active bar background
let s:base01  = [ '#504945', 241 ] " bar info (file, branch) background
let s:base00  = [ '#4f4844', 243 ] " inactive bar dim text (percent)
let s:base0   = [ '#7c6f64', 243 ] " active bar right most portion background
let s:base1   = [ '#7b6e63', 244 ] " active bar dim text (percent)
let s:base2   = [ '#73695a', 245 ] " active tab text, active bar right hand text
let s:base3   = [ '#a79983', 246 ] " active bar main text
let s:yellow  = [ '#fdc65a',  11 ]
let s:orange  = [ '#ff604c',  09 ]
let s:red     = [ '#d9382f',  01 ]
let s:magenta = [ '#c17996',  05 ]
let s:blue    = [ '#539699',  04 ]
let s:cyan    = s:blue
let s:green   = [ '#79aa82',  06 ]
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:base03, s:green ], [ s:base3, s:base01 ] ]
let s:p.normal.right = [ [ s:base02, s:base0 ], [ s:base1, s:base01 ] ]
let s:p.inactive.right = [ [ s:base023, s:base01 ], [ s:base00, s:base02 ] ]
let s:p.inactive.left =  [ [ s:base1, s:base02 ], [ s:base00, s:base023 ] ]
let s:p.insert.left = [ [ s:base03, s:blue ], [ s:base3, s:base01 ] ]
let s:p.replace.left = [ [ s:base03, s:red ], [ s:base3, s:base01 ] ]
let s:p.visual.left = [ [ s:base03, s:orange ], [ s:base3, s:base01 ] ]
let s:p.normal.middle = [ [ s:base2, s:base02 ] ]
let s:p.inactive.middle = [ [ s:base1, s:base023 ] ]
let s:p.tabline.left = [ [ s:base3, s:base00 ] ]
let s:p.tabline.tabsel = [ [ s:base2, s:base023 ] ]
let s:p.tabline.middle = [ [ s:base02, s:base1 ] ]
let s:p.tabline.right = [ [ s:base2, s:base01 ] ]
let s:p.normal.error = [ [ s:base03, s:red ] ]
let s:p.normal.warning = [ [ s:base023, s:yellow ] ]

let g:lightline#colorscheme#gruvbox#palette = lightline#colorscheme#flatten(s:p)
