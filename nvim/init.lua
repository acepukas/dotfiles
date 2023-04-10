local home_dir = os.getenv('HOME')

local fn = vim.fn

local Plug = fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

Plug 'sainnhe/gruvbox-material'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

-- Plug('fatih/vim-go', {['do'] = ':GoUpdateBinaries'})
Plug 'rhysd/vim-go-impl'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'onsails/lspkind-nvim'
Plug 'RRethy/vim-illuminate'
Plug('L3MON4D3/LuaSnip', {['tag'] = 'v1.*', ['do'] = 'make install_jsregexp'})
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'windwp/nvim-autopairs'

Plug 'nvim-telescope/telescope.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make' })
Plug 'nvim-telescope/telescope-rg.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'Slotos/telescope-lsp-handlers.nvim'

Plug('rrethy/vim-hexokinase', {['do'] = 'make hexokinase' })

Plug 'ur4ltz/surround.nvim'

Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'kyazdani42/nvim-web-devicons'

Plug 'kosayoda/nvim-lightbulb'
Plug 'antoinemadec/FixCursorHold.nvim'

Plug('akinsho/toggleterm.nvim', {['tag'] = '2.3.0'})

Plug 'cdelledonne/vim-cmake'

Plug 'alexghergh/nvim-tmux-navigation'
Plug 'KabbAmine/zeavim.vim'

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

local hlgroups = {
  'htmlTSTag',
  'htmlTagName',
  'htmlTagN',
  'xmlTagName',
  'javascriptTSTag',
  'jsxTagName',
  'tsxTagName',
  'tsxTSTag'
}

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
-- autocmd('BufEnter', { pattern = '*', command = 'set fo-=c fo-=r fo -=o'})

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
    'yaml',
    'markdown',
    'markdown_inline',
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
local luasnip = require'luasnip'
luasnip.config.set_config({
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave',
})
require'luasnip.loaders.from_vscode'.lazy_load({ paths = { './plugged/friendly-snippets' } })

map("i", "<C-h>", "<Plug>luasnip-next-choice", default_opts)
map("s", "<C-h>", "<Plug>luasnip-next-choice", default_opts)

-- nvim-cmp

vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

opt.completeopt = 'menu,menuone,noselect'

-- Function for cmp-path which returns the current working directory
local cwd = function()
  return vim.fn.getcwd()
end

-- Function for cmp-buffer to source all open buffers, not just current one
local get_bufnrs = function()
  return vim.api.nvim_list_bufs()
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
    }),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.close()
    }),
    ["<C-q>"] = cmp.mapping({
      i = cmp.mapping.abort()
    }),
    ['<C-Space>'] = cmp.mapping({i = cmp.mapping.complete()}),
    ['<C-d>'] = cmp.mapping({i = cmp.mapping.scroll_docs(-4)}),
    ['<C-f>'] = cmp.mapping({i = cmp.mapping.scroll_docs(4)}),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 8 },
    { name = 'luasnip', priority = 7 },
    { name = 'nvim_lua', priority = 5 },
    { name = 'nvim_lsp_signature_help' },
  }, {
    { name = 'path', priority = 5, option = { get_cwd = cwd } },
    { name = 'buffer', option = { get_bufnrs = get_bufnrs } },
  }),
  sorting = {
    priority_weight = 1.0,
    comparators = {
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.order,
    }
  },
  formatting = {
    format = require'lspkind'.cmp_format({with_text = true, maxwidth = 50})
  },
})

-- nvim-autopairs - this config must come after nvim-cmp's config
require'nvim-autopairs'.setup{}
local cmp_autopairs = require'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

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
require'lspconfig.configs'
local caps = vim.lsp.protocol.make_client_capabilities()
caps.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.emmet_ls.setup({
  capabilities = caps,
  filetypes = {'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less'},
})

local on_attach = function(client, bufnr)

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  cmd('command! LspDec lua vim.lsp.buf.declaration()')
  cmd('command! LspDef lua vim.lsp.buf.definition()')
  cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
  cmd('command! LspHover lua vim.lsp.buf.hover()')
  cmd('command! LspRename lua vim.lsp.buf.rename()')
  cmd('command! LspRefs lua vim.lsp.buf.references()')
  cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
  cmd('command! LspDiagPrev lua vim.diagnostic.goto_prev()')
  cmd('command! LspDiagNext lua vim.diagnostic.goto_next()')
  cmd('command! LspDiagLine lua vim.diagnostic.open_float()')
  cmd('command! LspDiagSetLocList lua vim.diagnostic.setloclist()')
  cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
  cmd('command! LspAddWorkspaceFolder lua vim.lsp.buf.add_workspace_folder()')
  cmd('command! LspRemoveWorkspaceFolder lua vim.lsp.buf.remove_workspace_folder()')

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

  require'illuminate'.on_attach(client)

end

local util = require('vim.lsp.util')

local make_autocmd_format_callback = function(client, bufnr)
  return function(args)
    local wait_ms = args.data
    local params = util.make_formatting_params({})
    local result, err = client.request_sync(
      "textDocument/formatting", params, wait_ms, bufnr)
    if result and result.result then
      local enc = (client or {}).offset_encoding or "utf-16"
      util.apply_text_edits(result.result, bufnr, enc)
    elseif err then
      vim.notify("make_autocmd_format_callback: " .. err, vim.log.levels.WARN)
    end
  end
end

local lspFmtGrp = vim.api.nvim_create_augroup("LspFormatting", {})

local autocmd_format_callback = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = lspFmtGrp, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lspFmtGrp,
      buffer = bufnr,
      callback = make_autocmd_format_callback(client, bufnr),
    })
  end
end

local make_go_imports_callback = function(client, bufnr)
  return function(args)
    local wait_ms = args.data
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result, err =
      client.request_sync("textDocument/codeAction", params, wait_ms, bufnr)
    if result and result.result then
      for _, res in pairs(result or {}) do
        for _, r in pairs(res or {}) do
          if r.edit then
            local enc = (client or {}).offset_encoding or "utf-16"
            util.apply_workspace_edit(r.edit, enc)
          end
        end
      end
    elseif err then
      vim.notify("make_go_imports_callback: " .. err, vim.log.levels.WARN)
    end
  end
end

local make_go_save_callback = function(client, bufnr)
  return function(args)
    make_go_imports_callback(client, bufnr)(args)
    make_autocmd_format_callback(client, bufnr)(args)
  end
end

local lspGoSaveUtils = vim.api.nvim_create_augroup("LspGoImports", {})

local attach_go_save_utils = function(client, bufnr)
  if client.supports_method("textDocument/formatting") and
    client.supports_method("textDocument/codeAction") then
    vim.api.nvim_clear_autocmds({ group = lspGoSaveUtils, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lspGoSaveUtils,
      buffer = bufnr,
      callback = make_go_save_callback(client, bufnr)
    })
  end
end

-- loop over language servers and apply config to each one
local servers = { 'gopls', 'lua_ls', 'clangd', 'tsserver' }
for _, server in ipairs(servers) do
  local setup = {
    on_attach = on_attach,
    capabilities = require'cmp_nvim_lsp'.default_capabilities(
      vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    },
  }
  if server == 'lua_ls' then
    require'acepukas.luals'.setup(setup)
  elseif server == 'ccls' then
    setup = vim.tbl_deep_extend("force", setup, {
      cmd = {'ccls'},
      filetype = {"c", "cpp"},
      root_dir = nvim_lsp.util.root_pattern("compile_commands.json",
        "compile_flags.txt", ".git"),
    })
  elseif server == 'clangd' then
    setup = vim.tbl_deep_extend("force", setup, {
      capabilities = {
       -- needed to supress annoying encoding warning
        offsetEncoding = { 'utf-16' }
      }
    })
  elseif server == 'gopls' then
    setup = vim.tbl_deep_extend("force", setup, {
      settings = {
        gopls = {
          gofumpt = true,
          usePlaceholders = true,
          linksInHover = false,
        }
      },
      init_options = {
        usePlaceholders = true
      },
      on_attach = function(client, bufnr)
        attach_go_save_utils(client, bufnr)
        on_attach(client, bufnr)
      end
    })
  end
  nvim_lsp[server].setup(setup)
end

-- null-ls.nvim
local builtins = require("null-ls").builtins
require("null-ls").setup({
  sources = {
    builtins.formatting.prettier.with({
      extra_args = {
        "--single-quote",
        "--trailing-comma", "all",
        "--no-bracket-spacing",
      }
    }),
    builtins.formatting.trim_newlines,
    builtins.formatting.trim_whitespace,
    builtins.diagnostics.xo.with({
      extra_args = { "--prettier", "--space" }
    }),
    builtins.diagnostics.revive,
    builtins.code_actions.gitsigns,
  },
  on_attach = function(client, bufnr)
    -- if lsp client is gopls, do not attach formatter to client
    if client.name ~= 'gopls' then
      autocmd_format_callback(client, bufnr)
    end
  end
})

local telescope = require'telescope'

-- telescope.nvim
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    }
  },
}

require'telescope'.load_extension('fzf')
require'telescope'.load_extension('live_grep_args')
require'telescope'.load_extension('ui-select')

-- telescope lsp handlers
require'telescope-lsp-handlers'.setup()

map('n', '<leader><Tab>', '<cmd>Telescope buffers<CR>', default_opts)
map('n', '<C-p>', '<cmd>Telescope find_files<CR>', default_opts)
-- vimgrep_arguments are custom here to ensure case sensitivity and word boundary are respected
map('n', '<leader>*', '<cmd>Telescope grep_string vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,-s,-w<CR>', default_opts)
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
    theme = 'gruvbox-material',
  },
  sections = {
    lualine_c = { { 'filename', path = 1 } }
  }
}

-- Comment.nvim
require'Comment'.setup()

-- nvim-lightbulb
require('nvim-lightbulb').setup({autocmd = {enabled = true}})

-- vim-cmake
g.cmake_link_compile_commands = 1

-- toggleterm
require("toggleterm").setup()

-- opens terminal. Can take 'count' prefix to specify terminal
-- map('n', '<c-\\>', '<cmd>exe v:count1 . "ToggleTerm"<CR>', default_opts)
--
-- function _G.set_terminal_keymaps()
--   local opts = {buffer = 0}
--   map('t', 'jk', [[<C-\><C-n>]], opts)
--   map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
--   map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
--   map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
--   map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
-- end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

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

-- sw-rasterizer settings

-- au BufNewFile,BufRead *path-possibly-using-globbing setlocal setting=value

local swRasterizerAuCmdGroup =
  vim.api.nvim_create_augroup("swRasterizerAuCmdGroup", {})

vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  once = true,
  group = swRasterizerAuCmdGroup,
  pattern = "/home/aaron/dev/cpp/sw-rasterizer/*",
  callback = function()
    g.cmake_default_config = "Release"
    map('n', '<F10>', ":!bash -c './" .. g.cmake_default_config .. "/rasterizer'<CR>", default_opts)
    map('n', '<F11>', ':CMakeGenerate<CR>', default_opts)
    map('n', '<F12>', ':CMakeBuild<CR>', default_opts)
  end,
})

-- nvim-tmux-navigation

map('n', '<c-h>', '<Cmd>NvimTmuxNavigateLeft<CR>')
map('n', '<c-j>', '<Cmd>NvimTmuxNavigateDown<CR>')
map('n', '<c-k>', '<Cmd>NvimTmuxNavigateUp<CR>')
map('n', '<c-l>', '<Cmd>NvimTmuxNavigateRight<CR>')
map('n', '<c-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>')
-- map('n', '<c-Space>', '<Cmd>NvimTmuxNavigateNext<CR>')

require'nvim-tmux-navigation'.setup{}

-- zeal.nvim
g.zv_file_types = {
  javascript = 'javascript,nodejs',
}
