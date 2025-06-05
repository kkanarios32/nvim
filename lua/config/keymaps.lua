vim.api.nvim_set_keymap("n", "bd", "<cmd>bd<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<CR>", {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex", -- or any filetype
  callback = function()
    -- normal mode keymap
    vim.api.nvim_set_keymap("n", "fs", "<cmd>TexlabForward<CR>", {})
  end,
})
