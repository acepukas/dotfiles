return {
  "dmtrKovalenko/fold-imports.nvim",
  opts = {},
  event = "BufRead",
  config = function()
    require("fold_imports").setup()
  end,
}
