local M = {}

function M.setup(opts)
  return vim.tbl_deep_extend("force", opts, {
    filetypes = {
      "html",
      "typescriptreact",
      "javascriptreact",
      "css",
      "sass",
      "scss",
      "less",
    },
  })
end

return M
