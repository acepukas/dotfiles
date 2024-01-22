local M = {}

function M.setup(opts)
  return vim.tbl_deep_extend("force", opts, {

  })
end

return M
