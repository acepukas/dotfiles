return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-rg.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "Slotos/telescope-lsp-handlers.nvim",
    },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
    },
    config = function(_, opts)
      local telescope = require'telescope'
      opts.extensions["ui-select"] = require("telescope.themes").get_dropdown{}
      telescope.setup(opts)
      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
      telescope.load_extension('ui-select')

      -- keymapping
      local map = require("util").map

      map('n', '<leader><Tab>', '<cmd>Telescope buffers<CR>', { desc = "List open buffers" })
      map('n', '<C-p>', '<cmd>Telescope find_files<CR>', { desc = "Recursive file fuzzy search" })
      -- vimgrep_arguments are custom here to ensure case sensitivity and word boundary are respected
      map('n', '<leader>*',
        '<cmd>Telescope grep_string vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,-s,-w<CR>',
        { desc = "Recursive search word under corsor" })
      map('n', '<leader>q', '<cmd>Telescope live_grep_args<CR>', { desc = "Live grep search" })
    end
  },
}
