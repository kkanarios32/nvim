return {
	"forester-browse",
	-- vimtex isn't required if using treesitter
	dir = "~/.config/nvim/lua/local/forester-browse/",
	dev = true,
	config = function()
		require("forester-browse").setup()
	end
}
