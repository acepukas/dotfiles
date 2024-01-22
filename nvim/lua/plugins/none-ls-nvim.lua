return {
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
}
