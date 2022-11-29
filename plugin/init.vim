" Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fs <cmd>lua require('telescope').extensions.ultisnips.ultisnips{}<cr>

let g:vimtex_compiler_enabled=0
let g:vimtex_complete_enabled=0
let g:vimtex_doc_enabled=0
let g:vimtex_fold_enabled=1
let g:vimtex_format_enabled=1
let g:vimtex_mappings_disable = {
    \ 'n': [ '<localleader>li', '<localleader>lI}', '<localleader>lt', '<localleader>lT', '<localleader>lq', '<localleader>lv', '<localleader>lr', '<localleader>ll', '<localleader>lL', '<localleader>lk', '<localleader>lK', '<localleader>le', '<localleader>lo', '<localleader>lg', '<localleader>lG', '<localleader>lc', '<localleader>lC', '<localleader>lx', '<localleader>lX', '<localleader>ls', '<localleader>la']
    \}
