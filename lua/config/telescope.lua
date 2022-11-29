local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim" -- add this value
      },
      mappings = {
        i = {
          ["<esc>"] = actions.close
        },
      },
  }
}

require('telescope').load_extension('ultisnips')

-- telescope-config.lua
local M = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

return M
