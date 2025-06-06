return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bibtex",
				"toml",
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"python",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				disable = { "latex" },
			},
			indent = { enable = true },
		},
		config = function()
			vim.filetype.add({ extension = { tree = "forester" } })

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.forester = {
				install_info = {
					url = "https://github.com/kentookura/tree-sitter-forester",
					files = { "src/parser.c" },
					branch = "main",
					generate_requires_npm = false,
					requires_generate_from_grammar = false,
				},
				filetype = "forester",
			}

			require("nvim-treesitter.configs").setup({
				ensure_installed = { "forester" },
				highlight = {
					enable = true
				}
			})
		end
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},
}
