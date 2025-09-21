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
        { text = "󰅚", hl = "Error" },
        { text = "󰀪", hl = "Warn" },
        { text = "󰋽", hl = "Info" },
        { text = "󰌶", hl = "Hint" },
      }

      for _, sign in ipairs(signs) do
        local signData = {
          text = sign.text,
          texthl = "DiagnosticSign" .. sign.hl,
        }
        vim.fn.sign_define(signData.texthl, signData)
      end

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
      }

      local confsDir = "plugins.lsp.servers."

      opts.servers = {
        gopls = require(confsDir .. "gopls").setup(setup),
        emmet_language_server = require(confsDir .. "emmet_language_server").setup(
          setup
        ),
        lua_ls = require(confsDir .. "luals").setup(setup),
        clangd = setup,
        -- hls = require(confsDir .. "hls").setup(setup),
        cssls = setup,
        html = setup,
        ts_ls = setup,
        pyright = setup,
        templ = setup,
      }

      for server, server_conf in pairs(opts.servers) do
        vim.lsp.config(server, server_conf)
        vim.lsp.enable(server)
      end
    end,
  },
}
