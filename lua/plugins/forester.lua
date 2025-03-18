return {
	"kentookura/forester.nvim",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-lua/plenary.nvim" },
	},
	-- -- maybe could be even lazier with these, but not working, because `forester` filetype is not registered yet
	-- ft = "tree",
	-- ft = "forester",
	config = function()
		-- can't run this because it treesitter might not be initialized
		-- vim.cmd.TSInstall "toml"

		-- this ensures that the treesitter is initialized, and toml is installed
		local configs = require("nvim-treesitter.configs")

		-- this ensures forester is initialized, makeing `forester` tree-sitter available
		require("forester").setup()

		-- installs the forester tree-sitter, so the syntax highlighting is available
		configs.setup({
			ensure_installed = { "toml", "forester" },
			sync_install = true,
		})
	end,
	keys = {
		{ "<localleader>n", "<cmd>Forester new<cr>", desc = "Forester - New" },
		{ "<localleader>b", "<cmd>Forester browse<cr>", desc = "Forester - Browse" },
		{ "<localleader>l", "<cmd>Forester link_new<cr>", desc = "Forester - Link New" },
		{ "<localleader>t", "<cmd>Forester transclude_new<cr>", desc = "Forester - Transclude New" },
		{
			"<localleader>c",
			function()
				local cmd = "just new"
				local prefix = vim.fn.input("Enter prefix: ")
				if not prefix:match("^[a-z]+$") or #prefix > 10 then
					print("Error: Prefix must be no more than 10 lowercase a-z characters.")
					return
				end
				if prefix ~= "" then
					cmd = cmd .. " " .. prefix
				else
					cmd = cmd .. " kak"
				end
				local file = io.popen(cmd):read("*a")
				vim.cmd("e " .. file)
			end,
			desc = "Forester - New from Command",
		},
	},
}
