return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "Slotos/telescope-lsp-handlers.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")
      opts = vim.tbl_extend("force", opts, {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          },
          live_grep_args = {
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
              },
            },
          },
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
          },
        },
      })
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("ui-select")

      -- keymapping
      local map = require("util").map

      map(
        "n",
        "<leader><Tab>",
        "<cmd>Telescope buffers<CR>",
        { desc = "List open buffers" }
      )
      map(
        "n",
        "<C-p>",
        "<cmd>Telescope find_files<CR>",
        { desc = "Recursive file fuzzy search" }
      )
      -- vimgrep_arguments are custom here to ensure case sensitivity and word boundary are respected
      local live_grep_args_shortcuts =
        require("telescope-live-grep-args.shortcuts")
      map("n", "<leader>*", function()
        live_grep_args_shortcuts.grep_word_under_cursor({
          postfix = " -F -s -w",
        })
      end, { desc = "Recursive search word under corsor" })
      map(
        "n",
        "<leader>q",
        "<cmd>Telescope live_grep_args<CR>",
        { desc = "Live grep search" }
      )
    end,
  },
}
