
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.termguicolors = true

opt.encoding = 'utf-8'
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.swapfile = false

opt.undolevels = 1000
opt.undofile = true
opt.undodir = vim.fn.expand('$HOME/.vimundo')

opt.number = true
opt.relativenumber = true
opt.showmatch = true
opt.foldmethod = 'marker'
opt.colorcolumn = '80'
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = false
opt.smartcase = false

opt.scrolloff = 7

opt.list = true
opt.listchars = {
  tab = '▸ ',
  trail = '.',
  eol = '¬',
  extends = '»',
  precedes = '«',
  nbsp = '⣿',
}
opt.showbreak = '↪ ' -- for wrapped lines

-- Perf
opt.hidden = true -- background buffers
opt.history = 100 -- remember 100 lines in command history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
