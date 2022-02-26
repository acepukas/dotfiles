local home_dir = os.getenv('HOME')

local fn = vim.fn

local Plug = fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

Plug 'sainnhe/gruvbox-material'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'ray-x/guihua.lua' -- float term, codeaction and codelens gui support

Plug 'ray-x/go.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'onsails/lspkind-nvim'
Plug 'RRethy/vim-illuminate'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'windwp/nvim-autopairs'

Plug 'nvim-telescope/telescope.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make' })

Plug('rrethy/vim-hexokinase', {['do'] = 'make hexokinase' })

Plug 'blackCauldron7/surround.nvim'

Plug 'lewis6991/gitsigns.nvim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'numToStr/Navigator.nvim'

Plug 'kyazdani42/nvim-web-devicons'

vim.call('plug#end')

local cmd = vim.cmd
-- local exec = vim.api.nvim_exec
local g = vim.g
local opt = vim.opt
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

g.mapleader = ' '
opt.encoding = 'utf-8'
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.swapfile = false

opt.undolevels = 1000
opt.undofile = true
opt.undodir = home_dir .. '/.vimundo'

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
opt.listchars = {tab = '▸ ', trail = '.', eol = '¬',
  extends = '»', precedes = '«', nbsp = '⣿'}
opt.showbreak = '↪ ' -- for wrapped lines

-- cmd [[au BufWrite * :%s/\s\+$//e]]

-- Perf
opt.hidden = true -- background buffers
opt.history = 100 -- remember 100 lines in command history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240

-- Colorscheme
opt.termguicolors = true

-- NORD COLORSCHEME CONFIG
-- g.nord_borders = true
-- g.nord_italic = false

-- cmd [[
-- augroup nord-theme-overrides
-- autocmd!
-- autocmd ColorScheme nord highlight Search ctermfg=11 ctermbg=0 gui=reverse guibg=#3B4252 guifg=#ebcb8b
-- augroup END
-- ]]
--
-- cmd [[colorscheme nord]]

cmd [[
augroup gruvbox-material-theme-overrides
autocmd!
autocmd ColorScheme gruvbox-material highlight link htmlTSTag Yellow
                                 \ | highlight link htmlTagName Yellow
                                 \ | highlight link jsxTagName Yellow
                                 \ | highlight link tsxTagName Yellow
                                 \ | highlight link tsxTSTag Yellow
augroup END
]]

g.gruvbox_material_enable_italic = 0
g.gruvbox_material_disable_italic_comment = 1
g.gruvbox_material_diagnostic_virtual_text = 'colored'
cmd [[colorscheme gruvbox-material]]

require'nvim-web-devicons'.setup{}

-- Tabs, Indent
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- don't auto comment new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- remove line length marker for selected file types
cmd [[autocmd FileType text,markdown,xml,html,xhtml setlocal cc=0]]

-- 2 spaces for selected file types
cmd [[
  autocmd FileType xml,html,xhtml,css,scss,javascript,typescript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-- terminal
cmd [[command Term :botright vsplit term://$SHELL]]

-- enter insert mode when switching to terminal
-- close terminal buffer on process exit
cmd [[
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufLeave term://* stopinsert
]]

-- tree-sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'comment',
    'cpp',
    'css',
    'dockerfile',
    'graphql',
    'go',
    'gomod',
    'haskell',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'php',
    'python',
    'regex',
    'scss',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'yaml'
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
  },
}

-- mappings
map('n', '<backspace>', ':nohl<CR>', default_opts)

map('', '<up>', '<nop>', {noremap = true})
map('', '<down>', '<nop>', {noremap = true})
map('', '<left>', '<nop>', {noremap = true})
map('', '<right>', '<nop>', {noremap = true})

map('v', 'J', ":m '>+1<CR>gv=gv", {noremap = true})
map('v', 'K', ":m '<-2<CR>gv=gv", {noremap = true})

-- luasnip
require'luasnip'
require'luasnip.loaders.from_vscode'.lazy_load({ paths = { './plugged/friendly-snippets' } })

map("i", "<C-j>", "<Plug>luasnip-expand-or-jump", {})
map("s", "<C-j>", "<Plug>luasnip-expand-or-jump", {})
map("i", "<C-k>", "<Plug>luasnip-jump-prev", {})
map("s", "<C-k>", "<Plug>luasnip-jump-prev", {})
map("i", "<C-h>", "<Plug>luasnip-next-choice", {})
map("s", "<C-h>", "<Plug>luasnip-next-choice", {})

-- nvim-cmp

vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

opt.completeopt = 'menu,menuone,noselect'

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm{
      behavior = cmp.ConfirmBehavior.insert,
      select = true,
    }
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
  },
  formatting = {
    format = require'lspkind'.cmp_format({with_text = true, maxwidth = 50})
  },
})

-- nvim-autopairs - this config must come after nvim-cmp's config
require'nvim-autopairs'.setup{}
local cmp_autopairs = require'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

require'cmp_luasnip'

-- go.nvim
require'go'.setup {
  goimport = 'gopls', -- if set to 'gopls' will use golsp format
  gofmt = 'gopls', -- if set to gopls will use golsp format
  max_line_len = 120,
  tag_transform = false,
  test_dir = '',
  comment_placeholder = '   ',
  lsp_cfg = true, -- false: use your own lspconfig
  lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = true, -- use on_attach from go.nvim
  dap_debug = true,
}

require'vim.lsp.protocol'

cmd [[autocmd BufWritePre (InsertLeave?) <buffer> lua vim.lsp.buf.formatting_sync(nil,500)]]

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

-- tree-sitter setup for golang template files
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"}
}

-- lspconfig

vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  severity_sort = true,
})

local nvim_lsp = require'lspconfig'

local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  cmd('command! LspDec lua vim.lsp.buf.declaration()')
  cmd('command! LspDef lua vim.lsp.buf.definition()')
  cmd('command! LspFormatting lua vim.lsp.buf.formatting()')
  cmd('command! LspCodeAction Telescope lsp_code_actions')
  cmd('command! LspHover lua vim.lsp.buf.hover()')
  cmd('command! LspRename lua vim.lsp.buf.rename()')
  cmd('command! LspOrganize lua lsp_organize_imports()')
  cmd('command! LspRefs lua vim.lsp.buf.references()')
  cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
  cmd('command! LspDiagPrev lua vim.diagnostic.goto_prev()')
  cmd('command! LspDiagNext lua vim.diagnostic.goto_next()')
  cmd('command! LspDiagLine lua vim.diagnostic.open_float()')
  cmd('command! LspDiagSetLocList lua vim.diagnostic.setloclist()')
  cmd('command! LspTypeDef lua vim.lsp.but.type_definition()')
  cmd('command! LspAddWorkspaceFolder lua vim.lsp.but.add_workspace_folder()')
  cmd('command! LspRemoveWorkspaceFolder lua vim.lsp.but.remove_workspace_folder()')

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', ':LspDec<CR>', opts)
  buf_set_keymap('n', 'gd', ':LspDef<CR>', opts)
  buf_set_keymap('n', 'K', ':LspHover<CR>', opts)
  buf_set_keymap('n', 'gi', ':LspImplementation<CR>', opts)
  buf_set_keymap('n', '<leader>wa', 'LspAddWorkspaceFolder<CR>', opts)
  buf_set_keymap('n', '<leader>wr', 'LspRemoveWorkspaceFolder<CR>', opts)
  buf_set_keymap('n', '<leader>D', ':LspTypeDef<CR>', opts)
  buf_set_keymap('n', '<leader>rn', ':LspRename<CR>', opts)
  buf_set_keymap('n', '<leader>ca', ':LspCodeAction<CR>', opts)
  buf_set_keymap('n', 'gr', ':LspRefs<CR>', opts)
  buf_set_keymap('n', '<leader>e', ':LspDiagLine<CR>', opts)
  buf_set_keymap('n', '[d', ':LspDiagPrev<CR>', opts)
  buf_set_keymap('n', ']d', ':LspDiagNext<CR>', opts)
  buf_set_keymap('n', '<leader>l', ':LspDiagSetLocList<CR>', opts)
  buf_set_keymap('n', '<leader>f', ':LspFormatting<CR>', opts)

  require'illuminate'.on_attach(client)

end

-- loop over language servers and apply config to each one
-- local servers = { 'gopls', 'sumneko_lua', 'ccls'}
local servers = { 'sumneko_lua', 'ccls'}
for _, lsp in ipairs(servers) do
  local setup = {
    on_attach = on_attach,
    capabilities = require'cmp_nvim_lsp'.update_capabilities(
      vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
  }
  if lsp == 'sumneko_lua' then
    require'acepukas.luals'.setup(setup)
  elseif lsp == 'ccls' then
    local ccls_conf = {
      cmd = {'ccls'},
      filetype = {"c", "cpp"},
      root_dir = nvim_lsp.util.root_pattern("compile_commands.json",
        "compile_flags.txt", ".git"),
    }
    for k, v in pairs(ccls_conf) do setup[k] = v end
  end
  nvim_lsp[lsp].setup(setup)
end

-- telescope.nvim
require'telescope'.setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}

require'telescope'.load_extension('fzf')

map('n', '<leader><Tab>', '<cmd>Telescope buffers<CR>', default_opts)
map('n', '<C-p>', '<cmd>Telescope find_files<CR>', default_opts)
map('n', '<leader>*', '<cmd>Telescope grep_string<CR>', default_opts)
map('n', '<leader>q', '<cmd>Telescope live_grep<CR>', default_opts)

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"
vim.cmd "autocmd User TelescopePreviewerLoaded setlocal relativenumber"

-- surround.nvim
require'surround'.setup {mappings_style = 'surround'}

-- gitsigns.nvim
require'gitsigns'.setup()

-- lualine.nvim
require'lualine'.setup {
  options = {
    theme = 'gruvbox-material'
  }
}

-- Comment.nvim
require'Comment'.setup()

-- typescript language server support
require'acepukas.typescriptls'

-- Navigator.nvim (for TMUX)
require'Navigator'.setup()
map('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>", default_opts)
map('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>", default_opts)
map('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>", default_opts)
map('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>", default_opts)
map('n', "<A-p>", "<CMD>lua require('Navigator').previous()<CR>", default_opts)
