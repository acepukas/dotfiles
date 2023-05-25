return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      vim.g.gruvbox_material_enable_italic = 0
      vim.g.gruvbox_material_disable_italic_comment = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.cmd([[colorscheme gruvbox-material]])
    end
  }
}
