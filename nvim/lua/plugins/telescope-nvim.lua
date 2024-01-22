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
    end
  },
}
