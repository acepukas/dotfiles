return {
  {
    "kyazdani42/nvim-web-devicons", lazy = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      return {
        options = {
          theme = 'gruvbox-material',
        },
        sections = {
          lualine_c = { { 'filename', path = 1 } }
        }
      }
    end
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = function()
      return {
        autocmd = {
          enabled = true,
        },
      }
    end
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },
}
