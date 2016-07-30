" -----------------------------------------------------------------------------
" Filename: autoload/lightline/colorscheme/base16ocean.vim
" Version: 0.1
" Author: Aaron Cepukas
" License: MIT License
" Last Change: 2015-06-25
" -----------------------------------------------------------------------------

let s:base03  = [ '#2b303b',  00 ] " mode label dark
let s:base023 = [ '#343d46',  10 ] " inactive bar background
let s:base02  = [ '#4f5b66',  11 ] " active bar background
let s:base01  = [ '#65737e',  08 ] " bar info (file, branch) background
let s:base00  = [ '#65737e',  08 ] " inactive bar dim text (percent)
let s:base0   = [ '#a7adba',  12 ] " active bar right most portion background
let s:base1   = [ '#a7adba',  12 ] " active bar dim text (percent)
let s:base2   = [ '#a7adba',  12 ] " active tab text, active bar right hand text
let s:base3   = [ '#dfe1e8',  13 ] " active bar main text
let s:yellow  = [ '#ebcb8b',  03 ]
let s:orange  = [ '#d08770',  09 ]
let s:red     = [ '#bf616a',  01 ]
let s:magenta = [ '#b48ead',  05 ]
let s:blue    = [ '#8fa1b3',  04 ]
let s:cyan    = [ '#96b5b4',  06 ]
let s:green   = [ '#a3be8c',  02 ]
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

let g:lightline#colorscheme#base16ocean#palette = lightline#colorscheme#flatten(s:p)
