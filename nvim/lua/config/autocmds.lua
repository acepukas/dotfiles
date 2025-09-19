local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Telescope
autocmd("User", {
  group = augroup("TelescopeAuGroup", {}),
  pattern = "TelescopePreviewerLoaded",
  command = "setlocal relativenumber",
})

local FormattingAuGroup = augroup("FormattingAuGroup", {})
-- remove line length marker for selected file types
autocmd("FileType", {
  group = FormattingAuGroup,
  pattern = "text,markdown,xml,html,xhtml,templ",
  command = "setlocal cc=0",
})

-- 2 spaces for selected file types
autocmd("FileType", {
  group = FormattingAuGroup,
  pattern = "xml,html,xhtml,css,scss,javascript,typescript,lua,yaml,templ",
  command = "setlocal shiftwidth=2 tabstop=2",
})

-- terminal
vim.cmd([[command Term :botright vsplit term://$SHELL]])

local TerminalAuGroup = augroup("TerminalAuGroup", {})
-- enter insert mode when switching to terminal
-- close terminal buffer on process exit
autocmd("TermOpen", {
  group = TerminalAuGroup,
  pattern = "*",
  command = "setlocal listchars= nonumber norelativenumber nocursorline",
})
autocmd("TermOpen", {
  group = TerminalAuGroup,
  pattern = "*",
  command = "startinsert",
})
autocmd("BufLeave", {
  group = TerminalAuGroup,
  pattern = "term://*",
  command = "stopinsert",
})

-- neovim built in commenting
autocmd({ "FileType" }, {
  desc = "Force commentstring to include spaces",
  group = augroup("commentStringIncludeSpacesAuGroup", {}),
  callback = function(event)
    local cs = vim.bo[event.buf].commentstring
    vim.bo[event.buf].commentstring = cs:gsub("(%S)%%s", "%1 %%s")
      :gsub("%%s(%S)", "%%s %1")
  end,
})

-- sw-rasterizer settings

-- au BufNewFile,BufRead *path-possibly-using-globbing setlocal setting=value

local map = require("util").map

autocmd({ "BufNewFile", "BufRead" }, {
  once = true,
  group = augroup("swRasterizerAuCmdGroup", {}),
  pattern = "/home/aaron/dev/cpp/sw-rasterizer/*",
  callback = function()
    vim.g.cmake_default_config = "Release"
    map(
      "n",
      "<F10>",
      ":!bash -c './" .. vim.g.cmake_default_config .. "/rasterizer'<CR>"
    )
    map("n", "<F11>", ":CMakeGenerate<CR>")
    map("n", "<F12>", ":CMakeBuild<CR>")
  end,
})

-- custom highlights for gruvbox-material
local function set_custom_highlights()
  vim.api.nvim_set_hl(0, "@constant.css", { link = "Character", bold = true })
end

set_custom_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_custom_highlights,
})
