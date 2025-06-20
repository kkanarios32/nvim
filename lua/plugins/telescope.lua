return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	config = function()
		local root = require("utils.root")
		root.setup()

		local builtins = require("fzf-lua")
		vim.keymap.set("n", "<leader>ff",
			function()
				builtins.files({ cwd = root() })
			end
		)
		vim.keymap.set("n", "<leader>/",
			function()
				builtins.live_grep({ cwd = root() })
			end
		)
		vim.keymap.set("n", "<leader>fc",
			function()
				builtins.files({ cwd = "/home/kellen/dotfiles/" })
			end
		)
	end
}
