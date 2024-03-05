local M = {}

function M.setup(opts)
  return vim.tbl_deep_extend("force", opts, {
    mason = false,
    settings = {
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
        linksInHover = false,
      },
    },
    init_options = {
      usePlaceholders = true,
    },
    on_attach = function(client, bufnr)
      require("plugins.lsp.format").attach_go_save_utils(client, bufnr)
      opts.on_attach(client, bufnr)
    end,
  })
end

return M
