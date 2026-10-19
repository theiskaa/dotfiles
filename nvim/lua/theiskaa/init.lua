vim.loader.enable()

require("theiskaa.options")
require("theiskaa.keymaps")
require("theiskaa.autocmds")
require("theiskaa.lazy")

function R(name)
	require("plenary.reload").reload_module(name)
end
