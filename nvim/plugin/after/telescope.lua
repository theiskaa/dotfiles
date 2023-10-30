local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-f>',  builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<C-w>',  builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<C-g>',  builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<C-d>',  builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<C-b>',  builtin.buffers, { desc = '[S]earch [B]uffers' })

-- Same keymap implementations of leader key:
vim.keymap.set('n', '<leader>f',  builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>h',  builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>w',  builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>g',  builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>d',  builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>?',  builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>',  builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

