local ls = require("luasnip") --{{{
local s = ls.s -- snippet
local i = ls.i -- insert node
local t = ls.t -- text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Go Snippets", { clear = true })
local file_pattern = "*.go"

local function cs(trigger, nodes, opts) --{{{
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Start Refactoring --

-- --                        TRIGGER
-- local myFirstSnippet = s("myFirstSnippet", {
--   t"Hi! This is my first snippet!", -- text node
--   i(1, "placeholder_text"),
--   t( {"first line of text node", "this is another text node"} ), -- text node
-- })
-- table.insert(snippets, myFirstSnippet)
--
-- local mySecondSnippet = s("mySecondSnippet", fmta([[
-- func <>(<>) {
--   <>
-- }
-- ]], {
--   i(1, "name"),
--   c(2, { t(""), t("myArg") }), -- choice node example
--   i(3, ""),
-- }))
-- table.insert(snippets, mySecondSnippet)
--
-- local myFirstAutosnippet = s({ trig = "digit%d", regTrig = true }, { t("This was auto triggered")})
-- table.insert(autosnippets, myFirstAutosnippet)

cs("method",
  fmta([[// <> <>
func <> <>(<>) <> {
  <>
}]], {
  i(1, "name"),
  i(2, "comment"),
  c(3, { sn(1, { t("("), i(1, "receiver"), t(" "), i(2, "*type"), t(")") } ), t("") } ),
  rep(1),
  c(4, { i(1, "args"), i(2) } ),
  c(5, { i(1, "error"), sn(2, { t("("), i(1, "types"), t(", error)") } ), t("") } ),
  i(6)
}))

-- End Refactoring --

return snippets, autosnippets
