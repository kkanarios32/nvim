vim.api.nvim_set_keymap("n", "bd", "<cmd>bd!<CR>", {})
vim.api.nvim_set_keymap("n", "bn", "<cmd>bn<CR>", {})
vim.api.nvim_set_keymap("n", "bp", "<cmd>bp<CR>", {})

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<CR>", {})

vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {})

vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex", -- or any filetype
  callback = function()
    -- normal mode keymap
    vim.api.nvim_set_keymap("n", "fs", "<cmd>TexlabForward<CR>", {})
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "forester", -- or any filetype
  callback = function()
    -- normal mode keymap
    vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Forester browse<CR>", {})
  end,
})
