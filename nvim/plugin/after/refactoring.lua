local ok, refactoring = pcall(require, 'refactoring')
if not ok then
    return
end

refactoring.setup({})

vim.api.nvim_set_keymap("v", "<leader>rr", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})
