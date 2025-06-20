return {
	{
		'f3fora/nvim-texlabconfig',
		config = function()
			require('texlabconfig').setup()
		end,
		ft = { 'tex', 'bib' }, -- Lazy-load on filetype
		build = 'go build -o ~/.local/bin/'
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({
					ensure_installed = { "isort", "basedpyright" },
				})
			end,
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ruff" },
			})
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"custom-luasnip-snippets.nvim",
				-- vimtex isn't required if using treesitter
				dir = "~/.config/nvim/lua/local/custom-luasnip-snippets.nvim/",
				dev = true,
				dependencies = {
					{
						"L3MON4D3/LuaSnip",
						version = "v2.*",
					},
					{
						"anki.nvim",
						dir = "~/.config/nvim/lua/local/anki.nvim/",
						dev = true,
						opts = {
							flashcard_dir = "/home/kellen/Projects/forest/flashcards/",
							filetypes = { "tex", "anki", "forester" },
						},
					},
					"lervag/vimtex",
				},
				config = function()
					require("custom-luasnip-snippets").setup({
						use_treesitter = true,
					})
					require("luasnip").config.setup({
						enable_autosnippets = true,
					})
					require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
				end,
			},
		},
		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "normal",
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "omni" },
			},

			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
}
