return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("util").has("nvim-cmp")
        end,
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        virtual_text = false,
        signs = true,
        severity_sort = true,
      },
      capabilities = {},
    },
    config = function(_, opts)

      local signs = {
        { text = "✗", hl = "Error" },
        { text = "", hl = "Warn" },
        { text = "", hl = "Information" },
        { text = "", hl = "Hint" },
      }

      for _, sign in ipairs(signs) do
        local signData = {
          text = sign.text,
          texthl = "DiagnosticSign" .. sign.hl,
        }
        vim.fn.sign_define("DiagnosticSign" .. sign.hl, signData)
      end

      local nvim_lsp = require("lspconfig")
      require('lspconfig.configs')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require'cmp_nvim_lsp'.default_capabilities(capabilities)

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      opts.capabilities = capabilities

      local setup = {
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        on_attach = require("plugins.lsp.keymaps").on_attach,
      }

      opts.servers = {
        gopls = require('plugins.lsp.servers.gopls').setup(setup),
        emmet_ls = require("plugins.lsp.servers.emmet").setup(setup),
        lua_ls = require("plugins.lsp.servers.luals").setup(setup),
        clangd = require("plugins.lsp.servers.clangd").setup(setup),
        -- ccls = require("plugins.lsp.servers.ccls").setup(setup),
      }

      for server, server_conf in pairs(opts.servers) do
        nvim_lsp[server].setup(server_conf)
      end

    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.prettier.with({
            extra_args = {
              "--single-quote",
              "--trailing-comma", "all",
              "--no-bracket-spacing",
            }
          }),
          nls.builtins.formatting.trim_newlines,
          nls.builtins.formatting.trim_whitespace,
          nls.builtins.diagnostics.xo.with({
            extra_args = { "--prettier", "--space" }
          }),
          nls.builtins.diagnostics.revive,
          nls.builtins.code_actions.gitsigns,
        },
        on_attach = function(client, bufnr)
          -- if lsp client is gopls, do not attach formatter to client
          if client.name ~= 'gopls' then
            require("plugins.lsp.format").autocmd_format_callback(client, bufnr)
          end
        end,
      }
    end,
  }
}
