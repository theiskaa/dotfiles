require('gruvbox').setup({
    disable_background = true
})

function ColorMyPencils(color)
	color = color or 'gruvbox-material'
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils("gruvbox-material") --> gruvbox, gruvbox-material, onedark, onedark_dark, minimal
