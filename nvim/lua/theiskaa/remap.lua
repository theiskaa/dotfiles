vim.g.mapleader = ","

vim.cmd [[command! W :w]]
vim.cmd [[command! Q :q]]
vim.cmd [[command! Wq :wq]]
vim.cmd [[command! WQ :wq]]

-- Text manipulation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("n", "<leader>rn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Rename word under cursor in file" })
vim.keymap.set("n", "df", vim.lsp.buf.format, { desc = "Format document" })

-- Clipboard operations
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- Window / Buffer management
vim.keymap.set('n', '<c-l>', '<c-w>l', { silent = true, desc = "Move to right window" })
vim.keymap.set('n', '<c-j>', '<c-w>j', { silent = true, desc = "Move to window below" })
vim.keymap.set('n', '<c-k>', '<c-w>k', { silent = true, desc = "Move to window above" })
vim.keymap.set('n', '<c-h>', '<c-w>h', { silent = true, desc = "Move to left window" })

-- Split management
vim.keymap.set('n', 'fsv', ':vs<CR>', { silent = true, desc = "Split vertically" })
vim.keymap.set('n', 'fsh', ':split<CR>', { silent = true, desc = "Split horizontally" })

-- Disable unhelpful keys
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- System commands
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Diagnostic navigation
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })

-- Plugin specific mappings
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true, desc = "Toggle file explorer" })

-- Diffview open/close
vim.keymap.set('n', '<leader><leader>', ':DiffviewOpen<CR>', { silent = true, desc = "Open diff view" })
vim.keymap.set('n', '<leader>z', ':DiffviewClose<CR>', { silent = true, desc = "Close diff view" })


-- Notifications
vim.keymap.set('n', '<leader>nd', function() require('notify').dismiss() end, { desc = "Dismiss notifications" })

-- Stupid stuff
vim.keymap.set("n", "<leader>s", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain effect" })
