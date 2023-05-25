local M = {}

function M.setup(opts)
  return vim.tbl_deep_extend("force", opts, {
    capabilities = {
     -- needed to supress annoying encoding warning
      offsetEncoding = { 'utf-16' }
    }
  })
end

return M
