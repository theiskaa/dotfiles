-- Undotree configuration
-- Set undotree window width and position
vim.g.undotree_WindowLayout = 2  -- Window layout #2 (right side)
vim.g.undotree_SplitWidth = 30   -- Set window width
vim.g.undotree_SetFocusWhenToggle = 1  -- Set focus to the undotree window when toggled

-- Make undotree plugin more resilient to data corruption
vim.g.undotree_ShortIndicators = 1  -- Use shorter timestamps

-- Map leader+u to toggle undotree
vim.keymap.set("n", "<leader>u", function()
  -- Try to toggle undotree safely
  pcall(function()
    vim.cmd.UndotreeToggle()
  end)
end, { desc = "Toggle Undotree" })
