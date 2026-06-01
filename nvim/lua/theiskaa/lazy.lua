-- Plugin management with lazy.nvim
-- Migrated from packer.nvim. Versions are pinned in lazy-lock.json.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.5",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		"f4z3r/gruvbox-material.nvim",
		{ "ellisonleao/gruvbox.nvim", name = "gruvbox" },
		"Mofiqul/vscode.nvim",

		-- Pin to the classic master branch: the config (plugin/after/treesitter.lua)
		-- uses the master-era `nvim-treesitter.configs` API, and the ecosystem
		-- plugins below need `nvim-treesitter.query`. The new `main` rewrite
		-- removes both.
		{ "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
		{ "nvim-treesitter/playground", dependencies = { "nvim-treesitter/nvim-treesitter" } },
		{ "nvim-treesitter/nvim-treesitter-context", dependencies = { "nvim-treesitter/nvim-treesitter" } },
		{ "nvim-treesitter/nvim-treesitter-refactor", dependencies = { "nvim-treesitter/nvim-treesitter" } },
		"theprimeagen/harpoon",
		-- Pinned to the last commit (2025-10-01) before refactoring.nvim added a
		-- hard `require("async")` luarocks dependency, which can't resolve without
		-- a luarocks backend. This commit keeps the `refactor('Inline Variable')`
		-- interface used in plugin/after/refactoring.lua and needs no rocks.
		{
			"theprimeagen/refactoring.nvim",
			commit = "bfd730f",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		},
		"mbbill/undotree",
		"RRethy/vim-illuminate",

		{
			"folke/trouble.nvim",
			opts = { icons = false },
		},
		"kevinhwang91/nvim-bqf",

		{ "neovim/nvim-lspconfig" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },

		-- Completion engine (LazyVim default)
		{
			"saghen/blink.cmp",
			version = "*", -- use a release tag with a prebuilt binary
			dependencies = { "rafamadriz/friendly-snippets" },
			opts = {
				keymap = { preset = "super-tab" },
				appearance = { nerd_font_variant = "mono" },
				completion = {
					documentation = { auto_show = true, auto_show_delay_ms = 200 },
					ghost_text = { enabled = true },
					menu = { border = "rounded" },
				},
				signature = { enabled = true, window = { border = "rounded" } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},

		-- Formatting (LazyVim default)
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofumpt" },
					python = { "ruff_format" },
					rust = { "rustfmt" },
					dart = { "dart_format" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					jsonc = { "prettierd", "prettier", stop_after_first = true },
					yaml = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
					markdown = { "prettierd", "prettier", stop_after_first = true },
				},
				format_on_save = function(bufnr)
					-- Allow disabling per-buffer/global via b:disable_autoformat
					if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
						return
					end
					return { timeout_ms = 1000, lsp_format = "fallback" }
				end,
			},
		},

		-- JSON/YAML schemas
		"b0o/schemastore.nvim",

		{
			"akinsho/flutter-tools.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"stevearc/dressing.nvim",
			},
		},

		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
				"s1n7ax/nvim-window-picker",
			},
		},
		"s1n7ax/nvim-window-picker",

		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		"rcarriga/nvim-notify",
		"stevearc/dressing.nvim",
		"folke/which-key.nvim",
		"lukas-reineke/indent-blankline.nvim",
		"norcalli/nvim-colorizer.lua",

		-- Auto-pairs (LazyVim default; replaces nvim-autopairs)
		{ "nvim-mini/mini.pairs", main = "mini.pairs", opts = {} },

		-- Treesitter-aware commentstring for the built-in gc/gcc mappings
		-- (handles JSX, embedded languages, etc.)
		{ "folke/ts-comments.nvim", opts = {} },

		"sindrets/diffview.nvim",
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			opts = {
				lazygit = { enabled = true },
				bigfile = { enabled = true },
				-- nvim-notify stays the notifier; do not enable snacks.notifier.
			},
		},

		"folke/zen-mode.nvim",
		"eandrju/cellular-automaton.nvim",
		"laytan/cloak.nvim",
		"xiyaowong/nvim-transparent",
	},

	defaults = { lazy = false },
	install = { colorscheme = { "gruvbox-material" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
