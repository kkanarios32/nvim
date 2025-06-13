return {
	"forester-browse",
	-- vimtex isn't required if using treesitter
	dir = "~/.config/nvim/lua/local/forester-browse/",
	dev = true,
	ft = "forester",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
		-- "nvim-telescope/telescope.nvim"
	},
	config = function()
		require("forester-browse").setup()
	end
}
