local cmd = vim.cmd

local function on_attach(client, bufnr)

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
  cmd('command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()')
  cmd('command! LspDiagNext lua vim.lsp.diagnostic.goto_next()')
  cmd('command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()')
  cmd('command! LspDiagSetLocList lua vim.lsp.diagnostic.set_loclist()')
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
  buf_set_keymap('n', '<leader>e', ':LispDiagLine<CR>', opts)
  buf_set_keymap('n', '[d', ':LspDiagPrev<CR>', opts)
  buf_set_keymap('n', ']d', ':LspDiagNext()<CR>', opts)
  buf_set_keymap('n', '<leader>l', ':LspDiagSetLocList<CR>', opts)
  buf_set_keymap('n', '<leader>f', ':LspFormatting<CR>', opts)

  require'illuminate'.on_attach(client)

end

local filetypes = {
  typescript = "eslint",
  typescriptreact = "eslint",
}

local linters = {
  eslint = {
    sourceName = "eslint",
    command = "eslint_d",
    rootPatterns = {".eslintrc.js", ".eslintrc.json", "package.json"},
    debounce = 100,
    args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
    parseJson = {
      errorsRoot = "[0].messages",
      line = "line",
      column = "column",
      endLine = "endLine",
      endColumn = "endColumn",
      message = "${message} [${ruleId}]",
      security = "severity",
    },
    securities = {[2] = "error", [1] = "warning"}
  }
}

local formatters = {
  prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}

local formatFiletypes = {
  typescript = "prettier",
  typescriptreact = "prettier",
}

local format_async = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then return end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winresetview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command("noautocmd :update")
    end
  end
end

vim.lsp.handlers["textDocument/formatting"] = format_async

_G.lsp_organize_imports = function()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_get_buf_name(0)},
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

local nvim_lsp = require('lspconfig')

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = vim.tbl_keys(filetypes),
  init_options = {
    filetypes = filetypes,
    linters = linters,
    formatters = formatters,
    formatFiletypes = formatFiletypes,
  }
}

nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
}
