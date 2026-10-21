return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = { flavour = "mocha" },
		config = function(_, opts)
			require("catppuccin").setup(opts)
			require("theiskaa.theme").set()
		end,
	},
}
