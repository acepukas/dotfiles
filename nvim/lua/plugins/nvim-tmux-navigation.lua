return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()

      -- keymapping
      local map = require("util").map

      map('n', '<c-h>', '<Cmd>NvimTmuxNavigateLeft<CR>')
      map('n', '<c-j>', '<Cmd>NvimTmuxNavigateDown<CR>')
      map('n', '<c-k>', '<Cmd>NvimTmuxNavigateUp<CR>')
      map('n', '<c-l>', '<Cmd>NvimTmuxNavigateRight<CR>')
      map('n', '<c-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>')
      -- map('n', '<c-Space>', '<Cmd>NvimTmuxNavigateNext<CR>')

    end,
  },
}
