local M = {}

function M.on_attach(client, bufnr)

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local cmd = vim.cmd

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

  local opts = { buffer=bufnr }
  local map = require("util").map
  local function setOpts(o)
    return vim.tbl_deep_extend("force", o, opts)
  end

  map('n', 'gD', ':LspDec<CR>', setOpts({ desc = "Declaration" }))
  map('n', 'gd', ':LspDef<CR>', setOpts({ desc = "Definition" }))
  map('n', 'K', ':LspHover<CR>', opts)
  map('n', 'gi', ':LspImplementation<CR>', setOpts({ desc = "Implementation" }))
  map('n', '<leader>wa', 'LspAddWorkspaceFolder<CR>', setOpts({ desc = "Add workspace Folder" }))
  map('n', '<leader>wr', 'LspRemoveWorkspaceFolder<CR>', setOpts({ desc = "Remove workspace Folder" }))
  map('n', '<leader>D', ':LspTypeDef<CR>', setOpts({ desc = "Type definition" }))
  map('n', '<leader>rn', ':LspRename<CR>', setOpts({ desc = "Rename" }))
  map('n', '<leader>ca', ':LspCodeAction<CR>', setOpts({ desc = "Code action" }))
  map('n', 'gr', ':LspRefs<CR>', setOpts({ desc = "References" }))
  map('n', '<leader>e', ':LspDiagLine<CR>', setOpts({ desc = "Show diagnostic" }))
  map('n', '[d', ':LspDiagPrev<CR>', setOpts({ desc = "Previous diagnostic" }))
  map('n', ']d', ':LspDiagNext<CR>', setOpts({ desc = "Next diagnostic" }))
  map('n', '<leader>l', ':LspDiagSetLocList<CR>', setOpts({ desc = "Dianostics to loclist" }))

  require'illuminate'.on_attach(client)

end

return M
