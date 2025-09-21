local M = {}

function M.setup(opts)
  return vim.tbl_deep_extend("force", opts, {
    mason = false,
    settings = {
      gopls = {
        gofumpt = false,
        usePlaceholders = true,
        linksInHover = false,
        ["build.templateExtensions"] = { "gohtml", "html" },
      },
    },
    filetypes = {
      "go",
      "gomod",
      "gowork",
      "gotmpl",
      "gotmpl.html",
    },
    init_options = {
      usePlaceholders = true,
    },
  })
end

return M
