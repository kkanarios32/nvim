require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "cpp",
        "lua",
    },
    highlight = {
        enable = true,
        disable = {"as"}
    },
    textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            },
        },
        lsp_interop = {
          enable = true,
          border = 'rounded',
          peek_definition_code = {
            ["df"] = "@function.outer",
            ["dc"] = "@class.outer",
      },
    },
  },
  rainbow = {
    enable = true,
    colors = {
      "#BF616A",
      "#EBCB8B",
      "#D08770",
      "#88C0D0",
      "#5E81AC",
      "#B48EAD",
    },
  }
}

