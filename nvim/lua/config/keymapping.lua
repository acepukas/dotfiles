local map = require("util").map

-- clear search hilighting with a backspace
map("n", "<backspace>", ":nohl<CR>")

-- disable arrow keys
map("", "<up>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")
map("", "<right>", "<nop>")

-- move selected lines up or down with J or K
map("x", "<M-j>", ":m '>+1<CR>gv=gv")
map("x", "<M-k>", ":m '<-2<CR>gv=gv")
map("n", "<M-k>", "ddkP")
map("n", "<M-j>", "ddp")

-- move around splits easy
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-l>", "<C-w><C-l>")

-- remap arrow keys for wildmenu
vim.cmd([[
set wildcharm=<C-Z>
let edit_re = '\(e\%[dit]\|v\?split\) '
cnoremap <expr> <up> getcmdline() =~# edit_re && wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> getcmdline() =~# edit_re && wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> getcmdline() =~# edit_re && wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> getcmdline() =~# edit_re && wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
]])

-- toggle spell check
map("n", "<leader>t", "<cmd>setlocal invspell<cr>", { desc = "Spell check toggle" })

-- zeal
local ft_map = {
  ["gotmpl.html"] = "html",
  sql = "psql",
  sh = "bash",
  javascript = "javascript,nodejs",
}

local function zeal_cmd(ft)
  for k, v in pairs(ft_map) do
    if k == ft then
      ft = v
      break
    end
  end
  return '<cmd>!zeal "' .. ft .. ':<cword>" &<cr><cr>'
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "zeal docs command",
  group = vim.api.nvim_create_augroup("zeal_command", { clear = true }),
  callback = function(opts)
    map("n", "gz", zeal_cmd(opts.match), { buffer = opts.buf, desc = "Open zeal doc for word under cursor" })
  end,
})

-- Global Diagnostic Keymaps (works with LSP servers and nvim-lint linters)
require("plugins.lsp.keymaps").diag_keymaps()

-- TEMPORARY: run a python script
-- map('n', '<F9>', ':echo system(\'python "\' . expand(\'%\') . \'"\')<cr>')
