vim.api.nvim_set_keymap("n", "bd", "<cmd>bd!<CR>", {})
vim.api.nvim_set_keymap("n", "bn", "<cmd>bn<CR>", {})
vim.api.nvim_set_keymap("n", "bp", "<cmd>bp<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>term<CR>", {})

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<CR>", {})

vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", {})

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
    vim.api.nvim_create_user_command("Tree", function(opts)
      local template = opts.args
      local filename = vim.fn.system("new " .. vim.fn.shellescape(template))
      vim.cmd("edit " .. vim.fn.fnamemodify(filename, ":p"))
    end, { nargs = 1 })
    vim.keymap.set("n", "<leader>go", function()
      local bufname = vim.api.nvim_buf_get_name(0)
      local filename = vim.fn.fnamemodify(bufname, ":t") -- "name.tree"
      local name = filename:match("^(.*)%.tree$")
      if name then
        local url = "http://localhost:1234/" .. name .. "/index.html"
        vim.fn.jobstart({ "qutebrowser", "--target", "window", url }, { detach = true })
      else
        print("Not a .tree file")
      end
    end, { desc = "Open .tree file in browser" })
  end
})
