return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          local plugin =
            require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin(
              "nvim-treesitter-textobjects"
            )
          end
        end,
      },
    },
    config = function()
      local function treesitter_enable(filetype)
        local WAIT_TIME = 1000 * 30 -- 30 seconds
        local lang = vim.treesitter.language.get_lang(filetype)
        if lang ~= nil then
          require("nvim-treesitter").install(lang):wait(WAIT_TIME)
          vim.api.nvim_create_autocmd("FileType", {
            desc = "Enable Treesitter features for " .. lang,
            pattern = vim.treesitter.language.get_filetypes(lang),
            callback = function()
              if vim.treesitter.query.get(lang, "highlights") then
                vim.treesitter.start()
              end
              if vim.treesitter.query.get(lang, "indents") then
                vim.bo.indentexpr =
                  "v:lua.require('nvim-treesitter').indentexpr()"
              end
              if vim.treesitter.query.get(lang, "folds") then
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
              end
            end,
          })
        end
      end

      local syntaxes = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "dockerfile",
        "graphql",
        "go",
        "gomod",
        "haskell",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "php",
        "python",
        "regex",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "markdown",
        "markdown_inline",
        "query",
        "gotmpl",
      }

      for _, syntax in ipairs(syntaxes) do
        treesitter_enable(syntax)
      end
    end,
  },
}
