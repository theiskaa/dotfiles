require('gruvbox').setup({
    disable_background = true
})

require('gruvbox-material').setup({
    italics = false,
    contrast = "medium",
    background = {
        transparent = true,
    },
    float = {
        force_background = false,
        background_color = nil,
    },
})

require('vscode').setup({
    transparent = true,
    italic_comments = true,
    underline_links = true,
    disable_nvimtree_bg = true,
    terminal_colors = true,
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },
})

-- Available Themes:
-- 1. gruvbox          (configured)
-- 2. gruvbox-material (configured)
-- 3. vscode           (configured)
-- 3. minimal          (not configured)
-- 4. atlas            (not configured)
function SetTheme(color)
    color = color or 'gruvbox-material'
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetTheme()
