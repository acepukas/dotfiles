return {
  "dgox16/devicon-colorscheme.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("devicon-colorscheme").setup({
      -- gruvbox-material colors
      colors = {
        orange = "#dc8c59",
        purple = "#c693a1",
        red = "#b85651",
        green = "#8F9A52",
        yellow = "#C18F41",
        blue = "#68948A",
        magenta = "#AB6C7D",
        cyan = "#72966C",
        white = "#d4be98",
        bright_orange = "#e78a4e",
        bright_purple = "#d3869b",
        bright_red = "#ea6962",
        bright_green = "#a9b665",
        bright_yellow = "#d8a657",
        bright_blue = "#7daea3",
        bright_magenta = "#d3869b",
        bright_cyan = "#89b482",
      },
    })
  end,
}
