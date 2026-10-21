local excluded = { ".git", "build", ".fvm", ".dart_tool", "target", ".next", ".open-next" }

local function pick(source, opts)
	return function()
		Snacks.picker[source](opts)
	end
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			lazygit = { enabled = true },
			input = { enabled = true },
			words = { enabled = true },
			indent = {
				enabled = true,
				indent = { char = "│" },
				scope = { enabled = false },
				animate = { enabled = false },
			},
			explorer = { enabled = true, replace_netrw = true },
			picker = {
				enabled = true,
				ui_select = true,
				-- Ghostty sends Ctrl-U for Cmd+Backspace; snacks maps it to list
				-- scrolling, so give it back to insert mode's delete-to-start.
				win = { input = { keys = { ["<c-u>"] = false } } },
				sources = {
					files = { hidden = true, ignored = true, exclude = excluded },
					grep = { hidden = true, ignored = true, exclude = excluded },
					grep_word = { hidden = true, ignored = true, exclude = excluded },
					explorer = {
						hidden = true,
						ignored = true,
						exclude = excluded,
						-- Build output churn (target/) keeps a watcher rescanning;
						-- the tree still refreshes on save and buffer enter.
						watch = false,
						layout = {
							preset = "sidebar",
							preview = false,
							hidden = { "input" },
							auto_hide = { "input" },
						},
						win = {
							list = {
								keys = {
									["Y"] = { "copy_path", desc = "Copy path to clipboard" },
									["O"] = "explorer_open",
									["q"] = false,
									["<Esc>"] = false,
								},
							},
						},
						actions = {
							copy_path = function(_, item)
								if item then
									vim.fn.setreg("+", item.file, "c")
								end
							end,
						},
					},
				},
			},
		},
		keys = {
			{ "<C-f>", pick("files"), desc = "[S]earch [F]iles" },
			{ "<C-w>", pick("grep_word"), desc = "[S]earch current [W]ord" },
			{ "<C-g>", pick("grep"), desc = "[S]earch by [G]rep" },
			{ "<C-d>", pick("diagnostics"), desc = "[S]earch [D]iagnostics" },
			{ "<C-b>", pick("buffers"), desc = "[S]earch [B]uffers" },
			{ "<leader>f", pick("files"), desc = "[S]earch [F]iles" },
			{ "<leader>h", pick("help"), desc = "[S]earch [H]elp" },
			{ "<leader>w", pick("grep_word"), desc = "[S]earch current [W]ord" },
			{ "<leader>g", pick("grep"), desc = "[S]earch by [G]rep" },
			{ "<leader>d", pick("diagnostics"), desc = "[S]earch [D]iagnostics" },
			{ "<leader>?", pick("recent"), desc = "[?] Find recently opened files" },
			{ "<leader><space>", pick("buffers"), desc = "[ ] Find existing buffers" },
			{ "<leader>/", pick("lines"), desc = "[/] Fuzzily search in current buffer" },
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "Toggle file explorer",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next reference",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev reference",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
				globalstatus = true,
				refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 300,
			plugins = {
				marks = true,
				registers = true,
				spelling = { enabled = true, suggestions = 20 },
			},
			win = { border = "rounded", padding = { 1, 2 } },
			layout = {
				width = { min = 20, max = 50 },
				spacing = 3,
				align = "left",
			},
			keys = { scroll_down = "<c-d>", scroll_up = "<c-u>" },
			sort = { "local", "order", "group", "alphanum", "mod" },
			expand = 1,
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
			},
		},
	},
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{
				"<leader>zz",
				function()
					require("zen-mode").toggle()
					vim.wo.wrap = false
					vim.wo.number = true
					vim.wo.rnu = true
					require("theiskaa.theme").set()
				end,
				desc = "Zen mode",
			},
		},
		opts = { window = { width = 120, options = {} } },
	},
}
