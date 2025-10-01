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
map(
  "n",
  "<leader>ts",
  "<cmd>setlocal invspell<cr>",
  { desc = "[T]oggle [S]pell check " }
)

map(
  "n",
  "<leader>tc",
  ":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>",
  { desc = "[T]oggle [C]onceallevel" }
)

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
    map(
      "n",
      "gz",
      zeal_cmd(opts.match),
      { buffer = opts.buf, desc = "Open zeal doc for word under cursor" }
    )
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

-- Used for LspAttach convenience
local opts = { noremap = true, silent = true }
local function setOpts(o)
  return vim.tbl_deep_extend("force", o, opts)
end

-- LspAttach executes code on the lsp attach event. Any code that can only be
-- set up as soon as the lsp has attached to a buffer should be placed in an
-- LspAttach auto command.
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = vim.api.nvim_create_augroup("my.lsp.keymaps", {}),
  callback = function(args)
    -- activate omnifunc
    vim.api.nvim_set_option_value(
      "omnifunc",
      "v:lua.vim.lsp.omnifunc",
      { buf = args.buf }
    )

    vim.cmd(
      "command! LspReferences lua require('telescope.builtin').lsp_references()"
    )
    vim.cmd("command! LspGotoDefinition lua vim.lsp.buf.definition()")
    vim.cmd(
      "command! LspAddWorkspaceFolder lua vim.lsp.buf.add_workspace_folder()"
    )
    vim.cmd(
      "command! LspRemoveWorkspaceFolder lua vim.lsp.buf.remove_workspace_folder()"
    )
    vim.cmd("command! LspDocumentSymbols lua vim.lsp.buf.document_symbol()")

    local buf_set_keymap = vim.api.nvim_buf_set_keymap
    -- use telescope for displaying references instead of neovim built in lsp api
    -- Map 'grr' to open Telescope's LSP references picker
    buf_set_keymap(
      args.buf,
      "n",
      "grr",
      "<cmd>LspReferences<cr>",
      setOpts({ desc = "References" })
    )
    -- goto definition mapping
    -- Map 'grd' to builtin LSP goto definition api
    buf_set_keymap(
      args.buf,
      "n",
      "grd",
      "<cmd>LspGotoDefinition<cr>",
      setOpts({ desc = "Goto Definition" })
    )
    -- document symbols mapping
    -- Map 'grs' to builtin LSP document symbols list
    buf_set_keymap(
      args.buf,
      "n",
      "grs",
      "<cmd>LspDocumentSymbols<cr>",
      setOpts({ desc = "Document Symbols" })
    )

    buf_set_keymap(
      args.buf,
      "n",
      "<leader>wa",
      "LspAddWorkspaceFolder<CR>",
      setOpts({ desc = "Add workspace Folder" })
    )

    buf_set_keymap(
      args.buf,
      "n",
      "<leader>wr",
      "LspRemoveWorkspaceFolder<CR>",
      setOpts({ desc = "Remove workspace Folder" })
    )
  end,
})

-- Use telescope for diagnostics list
-- Define a keymap to open a Telescope picker for diagnostics
map("n", "<leader>l", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Open Telescope diagnostics" })
