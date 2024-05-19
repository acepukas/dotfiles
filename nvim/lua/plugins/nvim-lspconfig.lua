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
        vim.fn.sign_define(signData.texthl, signData)
      end

      local nvim_lsp = require("lspconfig")
      require("lspconfig.configs")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- huh?
      opts.capabilities = capabilities

      local setup = {
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
        on_attach = require("plugins.lsp.keymaps").on_attach,
      }

      opts.servers = {
        gopls = require("plugins.lsp.servers.gopls").setup(setup),
        emmet_ls = require("plugins.lsp.servers.emmet").setup(setup),
        lua_ls = require("plugins.lsp.servers.luals").setup(setup),
        clangd = require("plugins.lsp.servers.clangd").setup(setup),
        -- ccls = require("plugins.lsp.servers.ccls").setup(setup),
        hls = require("plugins.lsp.servers.hls").setup(setup),
        cssls = require("plugins.lsp.servers.cssls").setup(setup),
        html = require("plugins.lsp.servers.html").setup(setup),
        tsserver = require("plugins.lsp.servers.tsserver").setup(setup),
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
}
