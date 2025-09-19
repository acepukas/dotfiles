local M = {}

local cmd = vim.cmd
local map = require("util").map

function M.on_attach(client, bufnr)
  local function buf_set_option(name, value)
    vim.api.nvim_set_option_value(name, value, { buf = bufnr })
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  cmd("command! LspAddWorkspaceFolder lua vim.lsp.buf.add_workspace_folder()")
  cmd("command! LspRemoveWorkspaceFolder lua vim.lsp.buf.remove_workspace_folder()")
  cmd("command! LspGotoDefinition lua vim.lsp.buf.definition()")

  local opts = { buffer = bufnr }
  local function setOpts(o)
    return vim.tbl_deep_extend("force", o, opts)
  end

  map(
    "n",
    "<leader>wa",
    "LspAddWorkspaceFolder<CR>",
    setOpts({ desc = "Add workspace Folder" })
  )
  map(
    "n",
    "<leader>wr",
    "LspRemoveWorkspaceFolder<CR>",
    setOpts({ desc = "Remove workspace Folder" })
  )
  map(
    "n",
    "<leader>cR",
    ":ClangdSwitchSourceHeader<cr>",
    setOpts({ desc = "Switch Source/Header (C/C++)" })
  )

  require("illuminate").on_attach(client)
end

return M
