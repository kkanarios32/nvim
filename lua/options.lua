-- global mappings
vim.g.mapleader = " " -- set leader to space

-- utilities
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
-- vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically

-- netrw
vim.g.netrw_banner = 0 -- no ugly banner
vim.g.netrw_browse_split = 0 -- open netrw in current buffer
    
-- leaving buffers
vim.opt.autowrite = true -- enable auto write
vim.opt.autowriteall = true -- enable auto write
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer

-- completion menu
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 5 -- Maximum number of entries in a popup
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

-- tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftround = true -- > and < are multiples of 2
  
-- go to last loc when opening a buffer
vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- Highlight on yank
vim.cmd("au TextYankPost * lua vim.highlight.on_yank {}")
