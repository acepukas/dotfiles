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

      local confsDir = "plugins.lsp.servers."

      opts.servers = {
        gopls = require(confsDir .. "gopls").setup(setup),
        emmet_language_server = require(confsDir .. "emmet_language_server").setup(
          setup
        ),
        lua_ls = require(confsDir .. "luals").setup(setup),
        clangd = require(confsDir .. "clangd").setup(setup),
        -- -- ccls = require(confsDir .. "ccls").setup(setup),
        -- hls = require(confsDir .. "hls").setup(setup),
        cssls = require(confsDir .. "cssls").setup(setup),
        html = require(confsDir .. "html").setup(setup),
        ts_ls = require(confsDir .. "tsserver").setup(setup),
        pyright = require(confsDir .. "pyright").setup(setup),
      }

      for server, server_conf in pairs(opts.servers) do
        nvim_lsp[server].setup(server_conf)
      end
    end,
  },
}
