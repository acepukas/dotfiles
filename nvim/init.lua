-- require("config")

require("config.options")

-- initialize lazy.nvim system requirements
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load lazy.nvim
require("lazy").setup("plugins", {
  dev = {
    path = "~/dev/neovim_plugins"
  },
  install = { colorscheme = { "gruvbox-material", "habamax" } },
})

require("config.keymapping")
require("config.autocmds")
