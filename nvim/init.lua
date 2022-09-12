local home_dir = os.getenv('HOME')

local fn = vim.fn

local Plug = fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

Plug 'sainnhe/gruvbox-material'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

Plug('fatih/vim-go', {['do'] = ':GoUpdateBinaries'})

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
Plug 'nvim-telescope/telescope-rg.nvim'

Plug('rrethy/vim-hexokinase', {['do'] = 'make hexokinase' })

Plug 'ur4ltz/surround.nvim'

Plug 'lewis6991/gitsigns.nvim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'kyazdani42/nvim-web-devicons'

vim.call('plug#end')

local cmd = vim.cmd
local autocmd = vim.api.nvim_create_autocmd
-- local exec = vim.api.nvim_exec
local g = vim.g
local opt = vim.opt
local map = vim.keymap.set
local default_opts = {silent = true}

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

-- Perf
opt.hidden = true -- background buffers
opt.history = 100 -- remember 100 lines in command history
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 240

-- Colorscheme
opt.termguicolors = true

vim.api.nvim_create_augroup('gruvbox-material-theme-overrides', {})

local hlgroups = { 'htmlTSTag', 'htmlTagName', 'jsxTagName', 'tsxTagName', 'tsxTSTag' }

for _,v in ipairs(hlgroups) do
  autocmd('ColorScheme', {
    pattern = 'gruvbox-material',
    command = string.gsub('highlight link GROUP Yellow', 'GROUP', v),
    group = 'gruvbox-material-theme-overrides'
  })
end

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
autocmd('BufEnter', { pattern = '*', command = 'set fo-=c fo-=r fo -=o'})

-- remove line length marker for selected file types
autocmd('FileType', {
  pattern = 'text,markdown,xml,html,xhtml',
  command = 'setlocal cc=0'
})

-- 2 spaces for selected file types
autocmd('FileType', {
  pattern = 'xml,html,xhtml,css,scss,javascript,typescript,lua,yaml',
  command = 'setlocal shiftwidth=2 tabstop=2'
})

-- terminal
cmd [[command Term :botright vsplit term://$SHELL]]

-- enter insert mode when switching to terminal
-- close terminal buffer on process exit
autocmd('TermOpen', {
  pattern = '*',
  command = 'setlocal listchars= nonumber norelativenumber nocursorline'
})
autocmd('TermOpen', { pattern = '*', command = 'startinsert'})
autocmd('BufLeave', { pattern = 'term://*', command = 'stopinsert'})

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

map('', '<up>', '<nop>', default_opts)
map('', '<down>', '<nop>', default_opts)
map('', '<left>', '<nop>', default_opts)
map('', '<right>', '<nop>', default_opts)

map('v', 'J', ":m '>+1<CR>gv=gv", default_opts)
map('v', 'K', ":m '<-2<CR>gv=gv", default_opts)

-- luasnip
require'luasnip'
require'luasnip.loaders.from_vscode'.lazy_load({ paths = { './plugged/friendly-snippets' } })

map("i", "<C-j>", "<Plug>luasnip-expand-or-jump", default_opts)
map("s", "<C-j>", "<Plug>luasnip-expand-or-jump", default_opts)
map("i", "<C-k>", "<Plug>luasnip-jump-prev", default_opts)
map("s", "<C-k>", "<Plug>luasnip-jump-prev", default_opts)
map("i", "<C-h>", "<Plug>luasnip-next-choice", default_opts)
map("s", "<C-h>", "<Plug>luasnip-next-choice", default_opts)

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
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm{
      behavior = cmp.ConfirmBehavior.insert,
      select = true,
    }
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
  }, {
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
  }),
  formatting = {
    format = require'lspkind'.cmp_format({with_text = true, maxwidth = 50})
  },
})

-- nvim-autopairs - this config must come after nvim-cmp's config
require'nvim-autopairs'.setup{}
local cmp_autopairs = require'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

require'cmp_luasnip'

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

  local opts = { buffer=bufnr, silent=true }

  map('n', 'gD', ':LspDec<CR>', opts)
  map('n', 'gd', ':LspDef<CR>', opts)
  map('n', 'K', ':LspHover<CR>', opts)
  map('n', 'gi', ':LspImplementation<CR>', opts)
  map('n', '<leader>wa', 'LspAddWorkspaceFolder<CR>', opts)
  map('n', '<leader>wr', 'LspRemoveWorkspaceFolder<CR>', opts)
  map('n', '<leader>D', ':LspTypeDef<CR>', opts)
  map('n', '<leader>rn', ':LspRename<CR>', opts)
  map('n', '<leader>ca', ':LspCodeAction<CR>', opts)
  map('n', 'gr', ':LspRefs<CR>', opts)
  map('n', '<leader>e', ':LspDiagLine<CR>', opts)
  map('n', '[d', ':LspDiagPrev<CR>', opts)
  map('n', ']d', ':LspDiagNext<CR>', opts)
  map('n', '<leader>l', ':LspDiagSetLocList<CR>', opts)
  map('n', '<leader>f', ':LspFormatting<CR>', opts)

  require'illuminate'.on_attach(client)

end

-- loop over language servers and apply config to each one
local servers = { 'gopls', 'sumneko_lua', 'ccls'}
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
require'telescope'.load_extension('live_grep_args')

map('n', '<leader><Tab>', '<cmd>Telescope buffers<CR>', default_opts)
map('n', '<C-p>', '<cmd>Telescope find_files<CR>', default_opts)
map('n', '<leader>*', '<cmd>Telescope grep_string<CR>', default_opts)
map('n', '<leader>q', '<cmd>Telescope live_grep_args<CR>', default_opts)

autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  command = 'setlocal number'
})
autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  command = 'setlocal relativenumber'
})

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

-- move lines around easy
map('n', '<A-j>', ':m .+1<CR>==', default_opts)
map('n', '<A-k>', ':m .-2<CR>==', default_opts)
map('v', '<A-j>', ":m '>+1<CR>gv=gv", default_opts)
map('v', '<A-k>', ":m '<-2<CR>gv=gv", default_opts)

-- move around splits easy
map('n', '<C-j>', '<C-w><C-j>', default_opts)
map('n', '<C-k>', '<C-w><C-k>', default_opts)
map('n', '<C-h>', '<C-w><C-h>', default_opts)
map('n', '<C-l>', '<C-w><C-l>', default_opts)
