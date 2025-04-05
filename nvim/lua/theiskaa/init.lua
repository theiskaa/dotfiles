-- Main configuration entry point for theiskaa's Neovim setup
require("theiskaa.set")
require("theiskaa.remap")
require("theiskaa.packer")

-- Create autogroups
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local theiskaaGroup = augroup('theiskaa', {})
local yank_group = augroup('HighlightYank', {})

-- Hot reload function for development
function R(name)
    require("plenary.reload").reload_module(name)
end

-- Highlight on yank
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 41,
        })
    end,
})

-- Remove trailing whitespace on save
autocmd({"BufWritePre"}, {
    group = theiskaaGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Netrw configuration
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Improve startup time
vim.loader.enable()
