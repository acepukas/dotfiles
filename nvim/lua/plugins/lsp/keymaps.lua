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

  local opts = { buffer=bufnr, silent=true }
  local map = vim.keymap.set

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

return M
