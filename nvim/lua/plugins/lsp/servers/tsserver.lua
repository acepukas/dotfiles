local M = {}

function M.setup(opts)
  local lspconfig = require("lspconfig")
  return vim.tbl_deep_extend("force", opts, {
    root_dir = lspconfig.util.root_pattern(".git", "package.json"),
  })
end

return M
