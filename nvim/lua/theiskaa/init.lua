require("theiskaa.set")
require("theiskaa.remap")
require("theiskaa.packer")

local augroup = vim.api.nvim_create_augroup
local theiskaaGroup = augroup('theiskaa', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

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

autocmd({"BufWritePre"}, {
    group = theiskaaGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
