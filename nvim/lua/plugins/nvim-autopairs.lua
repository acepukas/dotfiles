return {
  {
    "windwp/nvim-autopairs",
    dependencies = {
      "hrsh7th/nvim-cmp"
    },
    event = "InsertEnter",
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
      local cmp_autopairs = require'nvim-autopairs.completion.cmp'
      local on_confirm_done = cmp_autopairs.on_confirm_done({
        map_char = { tex = '' }
      })
      require("cmp").event:on('confirm_done', on_confirm_done)
    end
  },
}
