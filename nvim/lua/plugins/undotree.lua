return {
  {
    "mbbill/undotree",
    keys = {
      { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "undotree" },
    },
    config = function()

      -- keymapping
      local map = require("util").map

      map('n', '<F5>', ':UndotreeToggle<CR>')

    end,
  },
}
