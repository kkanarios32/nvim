local latex_args = {
	"--synctex-editor-command",
	[[nvim-texlabconfig -file '%{input}' -line %{line}]],
	"--synctex-forward",
	"%l:1:%f",
	"%p",
}

local function get_python_path(workspace)
	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
	end

	-- Find and use virtualenv in workspace directory.
	for _, pattern in ipairs({ "*", ".*" }) do
		local match = vim.fn.glob(vim.fs.joinpath(workspace, pattern, "pyvenv.cfg"))
		if match ~= "" then
			return vim.fs.joinpath(vim.fs.dirname(match), "bin", "python")
		end
	end

	-- Fallback to system Python.
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({
					ensure_installed = { "black", "isort" },
				})
			end,
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "pylsp" },
			})
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"saghen/blink.compat",
				-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
				version = "*",
				-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
				lazy = true,
				-- make sure to set opts so that lazy.nvim calls blink.compat's setup
				opts = {},
				config = function()
					local blink = require("blink.compat.registry")
					local forester_completion = require("forester.completion")
					blink.register_source("forester", forester_completion)
				end,
			},
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
					require("custom-luasnip-snippets").setup()
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
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-e: Hide menu
			-- C-k: Toggle signature help
			--
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = "default" },

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "forester" },
				providers = {
					forester = {
						enabled = function()
							return vim.tbl_contains({ "forester" }, vim.bo.filetype)
						end,
						name = "forester",
						module = "blink.compat.source",
					},
				},
			},

			-- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
	-- LSP servers and clients communicate what features they support through "capabilities".
	--  By default, Neovim support a subset of the LSP specification.
	--  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
	--  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
	--
	-- This can vary by config, but in-general for nvim-lspconfig:
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		opts = {
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = true,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = true,
			},
			-- Enable lsp cursor word highlighting
			document_highlight = {
				enabled = true,
			},
			-- add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			-- @type lspconfig.options
			servers = {
				lua_ls = {
					mason = true, -- set to false if you don't want this server to be installed with mason
					-- Use this to add any additional keymaps
					-- for specific lsp servers
					-- ---@type LazyKeysSpec[]
					-- keys = {},
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
				clangd = {
					cmd = {
						"clangd-18",
						"--background-index",
						"--suggest-missing-includes",
						"--clang-tidy",
						"--header-insertion=iwyu",
					},
				},
				texlab = {
					filetypes = { "plaintex", "tex", "bib" },
					settings = {
						texlab = {
							auxDirectory = ".",
							bibtexFormatter = "texlab",
							build = {
								args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
								executable = "latexmk",
								forwardSearchAfter = true,
								onSave = true,
							},
							chktex = {
								onEdit = true,
								onOpenAndSave = true,
							},
							diagnosticsDelay = 300,
							formatterLineLength = 80,
							forwardSearch = {
								executable = "zathura",
								args = latex_args,
								onSave = true,
							},
							latexFormatter = "latexindent",
							latexindent = {
								modifyLineBreaks = true,
							},
						},
					},
				},
				pyright = {
					settings = {
						python = {
							pythonPath = get_python_path(vim.fs.root(0, ".git")),
						},
					},
					on_attach = function(client, _)
						client.server_capabilities.hoverProvider = true
					end,
				},
			},
		},
		config = function(_, opts)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				end,
			})
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers or {}) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},
}
