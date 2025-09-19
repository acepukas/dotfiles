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

-- TEMPORARY: run a python script
-- map('n', '<F9>', ':echo system(\'python "\' . expand(\'%\') . \'"\')<cr>')

-- Adds numbered line jumps to the jump list (like 10j or 5k)
vim.keymap.set({ "n", "x" }, "j", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

-- use telescope for displaying references instead of neovim built in lsp api
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function(args)
    local buf_set_keymap = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true, desc = "References" }
    -- Map 'grr' to open Telescope's LSP references picker
    buf_set_keymap(
      args.buf,
      "n",
      "grr",
      '<cmd>lua require("telescope.builtin").lsp_references()<cr>',
      opts
    )
  end,
})

-- goto definition mapping
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function(args)
    local buf_set_keymap = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true, desc = "Goto Definition" }
    -- Map 'grd' to builtin LSP goto definition api
    buf_set_keymap(args.buf, "n", "grd", "<cmd>LspGotoDefinition<cr>", opts)
  end,
})

-- Use telescope for diagnostics list
-- Define a keymap to open a Telescope picker for diagnostics
vim.keymap.set("n", "<leader>l", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Open Telescope diagnostics" })
