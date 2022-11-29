local fn = vim.fn

local packer_install_dir = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

plug_url_format = 'https://github.com/%s'

local packer_repo = string.format(plug_url_format, 'wbthomason/packer.nvim')
local install_cmd = string.format('10split |term git clone --depth=1 %s %s', packer_repo, packer_install_dir)

-- auto-install packer in case it hasn't been installed.
if fn.glob(packer_install_dir) == '' then
  vim.api.nvim_echo({{'installing packer.nvim', 'type'}}, true, {})
  vim.cmd(install_cmd)
  vim.cmd('packadd packer.nvim') end

vim.cmd [[packadd packer.nvim]]

require('packer').startup({function(use)
  use({
    'lervag/vimtex',
    ft = {'tex', 'plaintex', 'bibtex'},
  })
  use({
    'SirVer/ultisnips',
    module = "ultisnips",
    requires = {{'honza/vim-snippets', rtp = '.'}},
    config = function()      
      vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'      
      vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
      vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
      vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end
  })
  use({
    "wbthomason/packer.nvim",
    opt = true,
  })
  use({
    "nvim-lua/plenary.nvim",
    module = "plenary"
  })
  use({
    "nvim-lua/popup.nvim",
    module = "popup"
  })
  use({
    "p00f/nvim-ts-rainbow", 
    module = "nvim-ts-rainbow",
  })
  use({
    "neovim/nvim-lspconfig",
    module = "nvim-lspconfig",
  })
  use({
    "onsails/lspkind-nvim",
    module = "lspkind-nvim",
  })
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({default = true})
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    module = "nvim-treesitter",
    run = ":TSUpdate",
  })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufRead",
    wants = {
      "nvim-treesitter",
      "nvim-ts-rainbow",
    },
    config = function()
      require('config.treesitter')
    end,
  })
  use({
    "hrsh7th/cmp-nvim-lsp", 
    event = "BufReadPre",
    wants = "nvim-lspconfig",
    config = function()
      require("config.lsp")
    end,
  })
  use({
    "nvim-telescope/telescope.nvim",
    opt = true,
    config = function()
      require("config.telescope")
    end,
    cmd = { "Telescope" },
    module = "telescope",
    keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
  })
  use({
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = "plenary.nvim",
    config = function()
      require("config.gitsigns")
    end,
  })
  use({
    "f-person/git-blame.nvim",
    event = "BufReadPre",
  })
  use({
    'dylanaraps/wal',
    ft = {'tex', 'plaintex', 'bibtex'},
  })
  use({
    "hoob3rt/lualine.nvim",
    event = "VimEnter",
    wants = "nvim-web-devicons",
    config = function()
      require("config.lualine")
    end,
  })
  use({
    {
      "tpope/vim-sleuth",
      event = "BufEnter",
      config = vim.cmd([[au BufEnter,BufWritePost * Sleuth]])
    },
    {
      "tpope/vim-commentary",
      event = "BufEnter"
    },
    {
      "tpope/vim-surround",
      event = "BufEnter",
    },
    {
      "tpope/vim-repeat",
      event = "BufEnter"
    },
  })
  use({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    wants = { 
      "ultisnips",
      "lspkind-nvim" 
    },
    requires = {
      { "quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp", },
      { "kdheepak/cmp-latex-symbols", after = "nvim-cmp", },
    },
    config = function()
      require("config.cmp")
    end
  })
  use({
    "aserowy/tmux.nvim",
    event = "BufEnter",
    config = function()
      require("config.tmux")
    end
  })
  use({
    "github/copilot.vim",
  })
end,
config = {
  profile = {
    enable = true,
    threshold = 0,
  },
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
  git = {
    default_url_format = plug_url_format
  }
}
})

