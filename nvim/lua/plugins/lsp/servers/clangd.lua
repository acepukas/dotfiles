local M = {}

function M.setup(opts)
  local _opts = vim.tbl_deep_extend("force", opts, {
    keys = {
      {
        "<leader>cR",
        "<cmd>ClangdSwitchSourceHeader<cr>",
        desc = "Switch Source/Header (C/C++)",
      },
    },
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern(
        "Makefile",
        "configure.ac",
        "configure.in",
        "config.h.in",
        "meson.build",
        "meson_options.txt",
        "build.ninja"
      )(fname) or require("lspconfig.util").root_pattern(
        "compile_commands.json",
        "compile_flags.txt"
      )(fname) or require("lspconfig.util").find_git_ancestor(fname)
    end,
    capabilities = {
      -- needed to supress annoying encoding warning
      offsetEncoding = { "utf-16" },
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  })

  local clangd_ext_opts = require("util").opts("clangd_extensions.nvim")
  require("clangd_extensions").setup(
    vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = _opts })
  )
  return _opts
end

return M
