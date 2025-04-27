-- require("config")

vim.deprecate = function() end

require("config.options")

-- initialize lazy.nvim system requirements
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable release
    lazyrepo,
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load lazy.nvim
require("lazy").setup("plugins", {
  dev = {
    path = "~/dev/neovim_plugins",
  },
  install = { colorscheme = { "gruvbox-material", "habamax" } },
  checker = { enabled = true },
})

require("config.keymapping")
require("config.autocmds")
