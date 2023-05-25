local autocmd = vim.api.nvim_create_autocmd

-- Telescope
autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  command = 'setlocal relativenumber'
})

-- remove line length marker for selected file types
autocmd('FileType', {
  pattern = 'text,markdown,xml,html,xhtml',
  command = 'setlocal cc=0'
})

-- 2 spaces for selected file types
autocmd('FileType', {
  pattern = 'xml,html,xhtml,css,scss,javascript,typescript,lua,yaml',
  command = 'setlocal shiftwidth=2 tabstop=2'
})

-- terminal
vim.cmd [[command Term :botright vsplit term://$SHELL]]

-- enter insert mode when switching to terminal
-- close terminal buffer on process exit
autocmd('TermOpen', {
  pattern = '*',
  command = 'setlocal listchars= nonumber norelativenumber nocursorline'
})
autocmd('TermOpen', { pattern = '*', command = 'startinsert'})
autocmd('BufLeave', { pattern = 'term://*', command = 'stopinsert'})


-- sw-rasterizer settings

-- au BufNewFile,BufRead *path-possibly-using-globbing setlocal setting=value

local default_opts = {silent = true}
local map = require("util").map
local swRasterizerAuCmdGroup =
  vim.api.nvim_create_augroup("swRasterizerAuCmdGroup", {})

vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
  once = true,
  group = swRasterizerAuCmdGroup,
  pattern = "/home/aaron/dev/cpp/sw-rasterizer/*",
  callback = function()
    vim.g.cmake_default_config = "Release"
    map('n', '<F10>', ":!bash -c './" .. vim.g.cmake_default_config .. "/rasterizer'<CR>", default_opts)
    map('n', '<F11>', ':CMakeGenerate<CR>', default_opts)
    map('n', '<F12>', ':CMakeBuild<CR>', default_opts)
  end,
})
