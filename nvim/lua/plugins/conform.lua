return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        templ = { "templ" },
      },
      format_on_save = {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500, -- active because async false
      },
      formatters = {
        templ = {
          command = "/home/aaron/go/bin/templ",
          args = { "fmt", "-stdin-filepath", "$FILENAME" },
          exit_codes = { 0, 1 },
        },
      },
    })
  end,
}
