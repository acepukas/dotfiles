return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'arkav/lualine-lsp-progress',
    },
    opts = function()
      return {
        options = {
          theme = 'gruvbox-material',
        },
        sections = {
          lualine_c = { { 'filename', path = 1 }, 'lsp_progress' },
        },
      }
    end,
  },
}
