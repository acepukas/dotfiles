return {
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require'luasnip'

      -- hopefully fixes the luasnip jump and dance
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*',
        callback = function()
          if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
              and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
              and not luasnip.session.jump_active
          then
            luasnip.unlink_current()
          end
        end
      })

      require'luasnip.loaders.from_vscode'.lazy_load({ paths = { '~/.local/share/nvim/lazy/friendly-snippets' } })
      require'luasnip.loaders.from_lua'.lazy_load({ paths = { '~/.config/nvim/snippets' } })

      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        ext_opts = {
          [require("luasnip.util.types").choiceNode] = {
            active = {
              virt_text = { { "*", "Title" }}
            }
          }
        }
      })


      -- keymapping
      local map = require("util").map

      map("i", "<C-h>", "<Plug>luasnip-next-choice")
      map("s", "<C-h>", "<Plug>luasnip-next-choice")
    end
  },
}
