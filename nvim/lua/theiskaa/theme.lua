local M = {}

M.transparent = true

local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"LineNr",
	"CursorLineNr",
	"SignColumn",
	"NonText",
	"EndOfBuffer",
}

local function clear_backgrounds()
	if not M.transparent then
		return
	end
	for _, name in ipairs(transparent_groups) do
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		hl.bg = nil
		hl.ctermbg = nil
		vim.api.nvim_set_hl(0, name, hl)
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("theiskaa_transparent", { clear = true }),
	callback = clear_backgrounds,
})

function M.set(color)
	vim.cmd.colorscheme(color or "vesper")
end

SetTheme = M.set

return M
