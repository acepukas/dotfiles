return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()

      -- keymapping
      local map = require("util").map

      map('n', '<leader>n', ':Neotree filesystem reveal left<CR>', { desc = 'Neotree' })

    end,
  },
}
