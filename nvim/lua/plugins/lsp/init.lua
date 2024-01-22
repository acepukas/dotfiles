return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
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
        { text = "⚠", hl = "Warn" },
        { text = "", hl = "Information" },
        { text = "?", hl = "Hint" },
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

      -- huh?
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
        hls = require("plugins.lsp.servers.hls").setup(setup),
        cssls = require("plugins.lsp.servers.cssls").setup(setup),
        html = require("plugins.lsp.servers.html").setup(setup),
      }

      for server, server_conf in pairs(opts.servers) do
        nvim_lsp[server].setup(server_conf)
      end

    end,
    -- setup = {
    --   clangd = function(_, opts)
    --     local clangd_ext_opts = require("util").opts("clangd_extensions.nvim")
    --     require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
    --     return false
    --   end,
    -- }
  },
  {
    "nvimtools/none-ls.nvim",
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
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  }
}
