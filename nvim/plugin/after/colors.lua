require('gruvbox').setup({
    disable_background = true
})

-- -- values shown are defaults and will be used if not provided
require('gruvbox-material').setup({
  italics = false,             -- enable italics in general
  contrast = "medium",        -- set contrast, can be any of "hard", "medium", "soft"
  comments = {
    italics = true,           -- enable italic comments
  },
  background = {
    transparent = true,      -- set the background to transparent
  },
  float = {
    force_background = false, -- force background on floats even when background.transparent is set
    background_color = nil,   -- set color for float backgrounds. If nil, uses the default color set
  },
  signs = {
    highlight = true,         -- whether to highlight signs
  },
})

function ColorMyPencils(color)
	color = color or 'gruvbox'
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils("gruvbox-material") --> gruvbox, gruvbox-material, onedark, onedark_dark, minimal
