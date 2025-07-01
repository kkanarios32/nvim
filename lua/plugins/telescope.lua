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
				builtins.files({ cwd = "$DOTFILES" })
			end
		)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "forester", -- or any filetype
			callback = function()
				-- normal mode keymap
				vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Forester browse<CR>", {})
				vim.keymap.set("n", "<leader>/",
					function()
						builtins.live_grep_glob({
							cmd = "rg -S --line-number --iglob *.tree",
							cwd = root(),
							silent = true,
						})
					end
				)
			end,
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "tex", -- or any filetype
			callback = function()
				vim.keymap.set("n", "<leader>/",
					function()
						builtins.live_grep({
							cmd = "rg -S --line-number --type-add tex:*{tex,sty,cls} --type tex",
							cwd = root(),
							silent = true,
						})
					end
				)
			end,
		})
	end
}
