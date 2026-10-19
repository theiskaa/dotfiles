return {
	{
		"datsfilipe/vesper.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function(_, opts)
			require("vesper").setup(opts)
			require("theiskaa.theme").set()
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		opts = { style = "dark", transparent = true, italic_comments = true },
	},
}
