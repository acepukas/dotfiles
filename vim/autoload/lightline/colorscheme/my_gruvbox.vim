" -----------------------------------------------------------------------------
" Filename: autoload/lightline/colorscheme/my_gruvbox.vim
" Version: 0.1
" Author: Aaron Cepukas
" License: MIT License
" Last Change: 2015-06-20
" -----------------------------------------------------------------------------

function! s:getGruvColor(group)
  let guiColor = synIDattr(hlID(a:group), "fg", "gui") 
  let termColor = synIDattr(hlID(a:group), "fg", "cterm") 
  return [ guiColor, termColor ]
endfunction

if exists('g:lightline')

  let s:bg0 = s:getGruvColor('GruvboxBg0')
  let s:bg1 = s:getGruvColor('GruvboxBg1')
  let s:bg2 = s:getGruvColor('GruvboxBg2')
  let s:bg3 = s:getGruvColor('GruvboxBg3')
  let s:bg4 = s:getGruvColor('GruvboxBg4')
  let s:fg0 = s:getGruvColor('GruvboxFg0')
  let s:fg1 = s:getGruvColor('GruvboxFg1')
  let s:fg2 = s:getGruvColor('GruvboxFg2')
  let s:fg3 = s:getGruvColor('GruvboxFg3')
  let s:fg4 = s:getGruvColor('GruvboxFg4')
  let s:gray = s:getGruvColor('GruvboxGray')

  let s:yellow = s:getGruvColor('GruvboxYellow')
  let s:blue   = s:getGruvColor('GruvboxBlue')
  let s:aqua   = s:getGruvColor('GruvboxAqua')
  let s:orange = s:getGruvColor('GruvboxOrange')
  let s:red    = s:getGruvColor('GruvboxRed')

  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left     = [ [ s:bg0, s:aqua ],   [ s:fg4, s:bg2 ] ]
  let s:p.normal.right    = [ [ s:bg0, s:aqua ],   [ s:gray, s:bg2 ] ]
  let s:p.normal.middle   = [ [ s:bg4, s:bg1 ] ]
  let s:p.inactive.left   = [ [ s:bg4, s:bg1 ],    [ s:bg4, s:bg1 ] ]
  let s:p.inactive.right  = [ [ s:bg4, s:bg1 ],    [ s:gray, s:bg1 ] ]
  let s:p.inactive.middle = [ [ s:bg4, s:bg1 ] ]
  let s:p.insert.left     = [ [ s:bg0, s:blue ],   [ s:fg4, s:bg2 ] ]
  let s:p.insert.right    = [ [ s:bg0, s:blue ],   [ s:gray, s:bg2 ] ]
  let s:p.insert.middle   = [ [ s:bg4, s:bg1 ] ]
  let s:p.replace.left    = [ [ s:bg0, s:red ],    [ s:fg4, s:bg2 ] ]
  let s:p.replace.right   = [ [ s:bg0, s:red ],    [ s:gray, s:bg2 ] ]
  let s:p.replace.middle  = [ [ s:bg4, s:bg1 ] ]
  let s:p.visual.left     = [ [ s:bg0, s:orange ], [ s:bg0, s:bg4 ] ]
  let s:p.visual.right    = [ [ s:bg0, s:orange ], [ s:bg0, s:bg4 ] ]
  let s:p.visual.middle   = [ [ s:bg4, s:bg1 ] ]
  let s:p.tabline.left    = [ [ s:bg4, s:bg2 ] ]
  let s:p.tabline.tabsel  = [ [ s:fg4, s:bg3 ] ]
  let s:p.tabline.middle  = [ [ s:bg0, s:bg1 ] ]
  let s:p.tabline.right   = [ [ s:bg0, s:orange ] ]
  let s:p.normal.error    = [ [ s:bg0, s:red ] ]
  let s:p.normal.warning  = [ [ s:bg0, s:yellow ] ]

  let g:lightline#colorscheme#my_gruvbox#palette = lightline#colorscheme#flatten(s:p)

endif
