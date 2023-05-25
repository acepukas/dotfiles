local M = {}

function M.setup(opts)
  return vim.tbl_deep_extend("force", opts, {
    cmd = {'ccls'},
    filetype = {"c", "cpp"},
    root_dir = require("lspconfig").util.root_pattern(
      "compile_commands.json",
      "compile_flags.txt",
      ".git"),
  })
end

return M
