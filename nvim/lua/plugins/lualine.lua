return {
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
}
