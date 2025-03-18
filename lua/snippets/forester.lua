local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

MATH_NODES = {
	display_math = true,
	inline_math = true,
}

function in_mathzone()
	local node = vim.treesitter.get_node({ ignore_injections = false })
	while node do
		if MATH_NODES[node:type()] then
			return true
		end
		node = node:parent()
	end
	return false
end

function not_in_mathzone()
	return not in_mathzone()
end

local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

-- local conds = require("luasnip.extras.expand_conditions")
local condition = pipe({ in_mathzone })

return {
	s("\\ul", { t({ "\\ul{", "  " }), i(1), t({ "", "}" }) }),
	s("\\ol", { t({ "\\ol{", "  " }), i(1), t({ "", "}" }) }),
	s("\\li", { t("\\li{"), i(1), t("}") }),
	s("\\p", { t("\\p{"), i(1), t("}") }),
	s("\\au", { t("\\author{kellenkanarios}") }),
	s("\\ba", { t("\\import{base-macros}") }),
	s("\\ti", { t("\\title{"), i(1), t("}") }),
	s({ trig = "mk", snippetType = "autosnippet", condition = not_in_mathzone }, { t("#{"), i(1), t("}") }),
	s({ trig = "dm", snippetType = "autosnippet", condition = not_in_mathzone }, { t("##{"), i(1), t("}") }),
	s({ trig = "ali", snippetType = "autosnippet", condition = condition }, {
		t({ "\\begin{align*}", "" }),
		i(1),
		t({ "", "\\end{align*}" }),
	}, {}),
	s("\\eq", {
		t({ "\\begin{equation}", "" }),
		i(1),
		t({ "", "\\end{equation}" }),
	}),
}, {
	type = "autosnippets",
	key = "forester_auto",
}
