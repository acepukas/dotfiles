local default_opts = {silent = true}
local map = require("util").map

-- clear search hilighting with a backspace
map('n', '<backspace>', ':nohl<CR>', default_opts)

-- disable arrow keys
map('', '<up>', '<nop>', default_opts)
map('', '<down>', '<nop>', default_opts)
map('', '<left>', '<nop>', default_opts)
map('', '<right>', '<nop>', default_opts)

-- move selected lines up or down with J or K
map('x', 'J', ":m '>+1<CR>gv=gv", default_opts)
map('x', 'K', ":m '<-2<CR>gv=gv", default_opts)

-- move around splits easy
map('n', '<C-j>', '<C-w><C-j>', default_opts)
map('n', '<C-k>', '<C-w><C-k>', default_opts)
map('n', '<C-h>', '<C-w><C-h>', default_opts)
map('n', '<C-l>', '<C-w><C-l>', default_opts)

-- remap arrow keys for wildmenu
vim.cmd [[
set wildcharm=<C-Z>
let edit_re = '\(e\%[dit]\|v\?split\) '
cnoremap <expr> <up> getcmdline() =~# edit_re && wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> getcmdline() =~# edit_re && wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> getcmdline() =~# edit_re && wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> getcmdline() =~# edit_re && wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
]]

-- luasnip
map("i", "<C-h>", "<Plug>luasnip-next-choice", default_opts)
map("s", "<C-h>", "<Plug>luasnip-next-choice", default_opts)

-- Telescope
map('n', '<leader><Tab>', '<cmd>Telescope buffers<CR>', default_opts)
map('n', '<C-p>', '<cmd>Telescope find_files<CR>', default_opts)
-- vimgrep_arguments are custom here to ensure case sensitivity and word boundary are respected
map('n', '<leader>*', '<cmd>Telescope grep_string vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,-s,-w<CR>', default_opts)
map('n', '<leader>q', '<cmd>Telescope live_grep_args<CR>', default_opts)

-- nvim-tmux-navigation
map('n', '<c-h>', '<Cmd>NvimTmuxNavigateLeft<CR>')
map('n', '<c-j>', '<Cmd>NvimTmuxNavigateDown<CR>')
map('n', '<c-k>', '<Cmd>NvimTmuxNavigateUp<CR>')
map('n', '<c-l>', '<Cmd>NvimTmuxNavigateRight<CR>')
map('n', '<c-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>')
-- map('n', '<c-Space>', '<Cmd>NvimTmuxNavigateNext<CR>')

-- undotree
map('n', '<F5>', ':UndotreeToggle<CR>', default_opts)

-- zeal
local ft_map = {
  ["gotmpl.html"] = "html",
  sql = "psql",
  sh = "bash",
  javascript = "javascript,nodejs"
}

local function zeal_cmd(ft)
  for k, v in pairs(ft_map) do
    if k == ft then
      ft = v
      break
    end
  end
  return "<cmd>!zeal \"" .. ft .. ":<cword>\" &<cr><cr>"
end

vim.api.nvim_create_autocmd('FileType', {
  desc = "zeal docs command",
  group = vim.api.nvim_create_augroup('zeal_command', { clear = true }),
  callback = function(opts)
    map('n', 'gz', zeal_cmd(opts.match), {silent = true, buffer = opts.buf})
  end,
})
