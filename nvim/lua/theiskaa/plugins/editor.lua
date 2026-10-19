return {
	{
		-- Pairs with vim-tmux-navigator in tmux.conf.
		"christoomey/vim-tmux-navigator",
		cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", silent = true, desc = "Move to left window" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", silent = true, desc = "Move to window below" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", silent = true, desc = "Move to window above" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", silent = true, desc = "Move to right window" },
		},
	},
	{
		"theprimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function()
			local keys = {
				{
					"<leader>a",
					function()
						require("harpoon.mark").add_file()
					end,
					desc = "Harpoon add file",
				},
				{
					"<C-e>",
					function()
						require("harpoon.ui").toggle_quick_menu()
					end,
					desc = "Harpoon menu",
				},
			}
			for i = 0, 7 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon.ui").nav_file(i)
					end,
					desc = "Harpoon file " .. i,
				})
			end
			return keys
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = {
			{ "<leader><leader>", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
			{ "<leader>z", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = require("gitsigns")
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
				end
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
			end,
		},
	},
	{
		-- Not lazy, so a .env opened from the command line is masked immediately.
		"laytan/cloak.nvim",
		lazy = false,
		opts = {
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			patterns = {
				{
					file_pattern = { ".env*", "wrangler.toml", ".dev.vars" },
					cloak_pattern = "=.+",
				},
			},
		},
	},
}
