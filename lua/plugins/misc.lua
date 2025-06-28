return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"tpope/vim-fugitive",
	"wakatime/vim-wakatime",
	{
		"EdenEast/nightfox.nvim",
		config = function()
			vim.cmd("colorscheme nordfox")
		end,
	},
}
