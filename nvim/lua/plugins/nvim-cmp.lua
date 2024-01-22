return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "p00f/clangd_extensions.nvim",
    },
    opts = function()

      vim.opt.completeopt = 'menu,menuone,noselect'

      -- Function for cmp-path which returns the current working directory
      local cwd = function()
        return vim.fn.getcwd()
      end

      -- Function for cmp-buffer to source all open buffers, not just current one
      local get_bufnrs = function()
        return vim.api.nvim_list_bufs()
      end

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require'luasnip'

      return {
        snippet = {
          expand = function(args)
            require'luasnip'.lsp_expand(args.body)
          end,
        },
        preselect = cmp.PreselectMode.None,
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          }),
          ["<C-e>"] = cmp.mapping(cmp.mapping.close(), {"i"}),
          ["<C-q>"] = cmp.mapping(cmp.mapping.abort(), {"i"}),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {"i"}),
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i"}),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i"}),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 8 },
          { name = 'luasnip', priority = 7 },
          { name = 'nvim_lua', priority = 5 },
          { name = 'nvim_lsp_signature_help' },
        }, {
          { name = 'path', priority = 5, option = { get_cwd = cwd } },
          { name = 'buffer', option = { get_bufnrs = get_bufnrs } },
        }),
        sorting = {
          priority_weight = 1.0,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          }
        },
        formatting = {
          format = require'lspkind'.cmp_format({with_text = true, maxwidth = 50})
        },
      }
    end,
  },
}
