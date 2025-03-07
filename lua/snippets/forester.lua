local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

MATH_NODES = {
	display_math = true,
	inline_math = true,
}

function pipe(fns)
	return function(...)
		for _, fn in ipairs(fns) do
			if not fn(...) then
				return false
			end
			return true
		end

		return true
	end
end

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

return {
	s("\\ul", { t({ "\\ul{", "  " }), i(1), t({ "", "}" }) }),
	s("\\ol", { t({ "\\ol{", "  " }), i(1), t({ "", "}" }) }),
	s("\\li", { t("\\li{"), i(1), t("}") }),
	s("\\p", { t("\\p{"), i(1), t("}") }),
	s("\\au", { t("\\author{kellenkanarios}") }),
	s("\\ba", { t("\\import{base-macros}") }),
	s("\\ti", { t("\\title{"), i(1), t("}") }),
	s({ trig = "mk", snippetType = "autosnippet" }, { t("#{"), i(1), t("}") }),
	s({ trig = "dm", snippetType = "autosnippet", condition = not_in_mathzone }, { t("##{"), i(1), t("}") }),
	s({ trig = "ali", snippetType = "autosnippet" }, {
		t({ "\\begin{aligned}", "" }),
		i(1),
		t({ "", "\\end{aligned}" }),
	}, {
		condition = pipe({ in_mathzone }),
	}),
	s("\\eq", {
		t({ "\\begin{equation}", "" }),
		i(1),
		t({ "", "\\end{equation}" }),
	}),
}, {
	type = "autosnippets",
	key = "forester_auto",
}
