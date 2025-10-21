return {
	'luk400/vim-jukit',
	config = function()
		-- ╔══════════════════════════════════════════════════════╗
		-- ║                  Jukit Split Commands                ║
		-- ╚══════════════════════════════════════════════════════╝

		-- Open splits
		vim.keymap.set('n', '<leader>os', ':call jukit#splits#output()<CR>', { noremap = true, silent = true, desc = "Open output split" })
		vim.keymap.set('n', '<leader>ts', ':call jukit#splits#term()<CR>', { noremap = true, silent = true, desc = "Open terminal split (no command)" })
		vim.keymap.set('n', '<leader>hs', ':call jukit#splits#history()<CR>', { noremap = true, silent = true, desc = "Open output history split" })
		vim.keymap.set('n', '<leader>ohs', ':call jukit#splits#output_and_history()<CR>', { noremap = true, silent = true, desc = "Open output and history splits" })

		-- Close splits
		vim.keymap.set('n', '<leader>hd', ':call jukit#splits#close_history()<CR>', { noremap = true, silent = true, desc = "Close history split" })
		vim.keymap.set('n', '<leader>od', ':call jukit#splits#close_output_split()<CR>', { noremap = true, silent = true, desc = "Close output split" })
		vim.keymap.set('n', '<leader>ohd', ':call jukit#splits#close_output_and_history(1)<CR>', { noremap = true, silent = true, desc = "Close output and history splits" })

		-- Show outputs
		vim.keymap.set('n', '<leader>so', ':call jukit#splits#show_last_cell_output(1)<CR>', { noremap = true, silent = true, desc = "Show last cell output in history" })

		-- Scroll output history
		vim.keymap.set('n', '<leader>j', ':call jukit#splits#out_hist_scroll(1)<CR>', { noremap = true, silent = true, desc = "Scroll down in output history" })
		vim.keymap.set('n', '<leader>k', ':call jukit#splits#out_hist_scroll(0)<CR>', { noremap = true, silent = true, desc = "Scroll up in output history" })

		-- Toggle auto history display
		vim.keymap.set('n', '<leader>ah', ':call jukit#splits#toggle_auto_hist()<CR>', { noremap = true, silent = true, desc = "Toggle auto history display" })

		-- Layouts
		vim.keymap.set('n', '<leader>sl', ':call jukit#layouts#set_layout()<CR>', { noremap = true, silent = true, desc = "Apply Jukit layout" })

		-- ╔══════════════════════════════════════════════════════╗
		-- ║                Sending Code to Output                ║
		-- ╚══════════════════════════════════════════════════════╝

		-- Send current section
		vim.keymap.set('n', '<leader><space>', ':call jukit#send#section(0)<CR>', { noremap = true, silent = true, desc = "Send current cell to output" })

		-- Send current line
		vim.keymap.set('n', '<CR>', ':call jukit#send#line()<CR>', { noremap = true, silent = true, desc = "Send current line to output" })

		-- Send visually selected code
		vim.keymap.set('v', '<CR>', ':<C-U>call jukit#send#selection()<CR>', { noremap = true, silent = true, desc = "Send selected code to output" })

		-- Run multiple cells
		vim.keymap.set('n', '<leader>cc', ':call jukit#send#until_current_section()<CR>', { noremap = true, silent = true, desc = "Run all cells up to current" })
		vim.keymap.set('n', '<leader>all', ':call jukit#send#all()<CR>', { noremap = true, silent = true, desc = "Run all cells" })

	-- Convert between .ipynb and .py
	vim.keymap.set('n', '<leader>np', ':call jukit#convert#notebook_convert("jupyter-notebook")<CR>', { noremap = true, silent = true, desc = "Convert notebook <-> script" })

	-- Convert to HTML (without rerunning cells)
	vim.keymap.set('n', '<leader>ht', ':call jukit#convert#save_nb_to_file(0,1,"html")<CR>', { noremap = true, silent = true, desc = "Convert notebook to HTML" })

	-- Convert to HTML (rerun all cells)
	vim.keymap.set('n', '<leader>rht', ':call jukit#convert#save_nb_to_file(1,1,"html")<CR>', { noremap = true, silent = true, desc = "Rerun and convert notebook to HTML" })

	-- Convert to PDF (without rerunning cells)
	vim.keymap.set('n', '<leader>pd', ':call jukit#convert#save_nb_to_file(0,1,"pdf")<CR>', { noremap = true, silent = true, desc = "Convert notebook to PDF" })

	-- Convert to PDF (rerun all cells)
	vim.keymap.set('n', '<leader>rpd', ':call jukit#convert#save_nb_to_file(1,1,"pdf")<CR>', { noremap = true, silent = true, desc = "Rerun and convert notebook to PDF" })
	end
}
