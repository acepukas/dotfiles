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
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.INFO] = "󰋽",
            [vim.diagnostic.severity.HINT] = "󰌶",
          },
        },
        severity_sort = true,
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local diagSignTypes = { "Error", "Warn", "Info", "Hint" }

      for i, sign in ipairs(diagSignTypes) do
        local signData = {
          text = opts.diagnostics.signs.text[i],
          texthl = "DiagnosticSign" .. sign,
        }
        vim.fn.sign_define(signData.texthl, signData)
      end

      require("lspconfig.configs")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local setup = {
        capabilities = capabilities,
        flags = { debounce_text_changes = 150 },
      }

      local reqConf = function(fname)
        return require("plugins.lsp.servers." .. fname)
      end

      local servers = {
        gopls = reqConf("gopls").setup(setup),
        emmet_language_server = reqConf("emmet_language_server").setup(setup),
        lua_ls = reqConf("luals").setup(setup),
        clangd = setup,
        -- hls = reqConf("hls").setup(setup),
        cssls = setup,
        html = setup,
        ts_ls = setup,
        pyright = setup,
        templ = setup,
      }

      for server, server_conf in pairs(servers) do
        vim.lsp.config(server, server_conf)
        vim.lsp.enable(server)
      end
    end,
  },
}
