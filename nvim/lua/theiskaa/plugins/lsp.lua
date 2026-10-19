local servers = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					},
				},
				completion = { callSnippet = "Replace" },
				diagnostics = { globals = { "vim", "Snacks" } },
				hint = { enable = true },
				telemetry = { enable = false },
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				gofumpt = true,
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				analyses = {
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				usePlaceholders = true,
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
				semanticTokens = true,
			},
		},
	},
	pyright = {
		settings = {
			python = {
				analysis = { typeCheckingMode = "basic" },
			},
		},
	},
	ruff = {},
	rust_analyzer = {
		settings = {
			-- clippy --all-features on every save was the main CPU/heat cost.
			["rust-analyzer"] = {
				checkOnSave = true,
				check = { command = "check" },
			},
		},
	},
	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "literal",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayVariableTypeHints = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
	jsonls = {},
	yamlls = {},
}

local function on_attach(event)
	local function map(mode, lhs, rhs, desc, extra)
		vim.keymap.set(
			mode,
			lhs,
			rhs,
			vim.tbl_extend("force", { buffer = event.buf, silent = true, desc = desc }, extra or {})
		)
	end

	-- nowait: otherwise gr waits for Neovim's default grr/grn/gra maps.
	map("n", "gd", vim.lsp.buf.definition, "Go to definition")
	map("n", "gr", vim.lsp.buf.references, "References", { nowait = true })
	map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
	map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
	map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	map("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, "Hover")
	map("n", "gK", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, "Signature help")
	map("i", "<C-k>", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, "Signature help")

	map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
	map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
	map("n", "<leader>cs", vim.lsp.buf.document_symbol, "Document symbols")
	map("n", "<leader>ci", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
	end, "Toggle inlay hints")

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
	end

	-- flutter-tools' color support is deprecated on 0.12; use the native one.
	if
		client
		and client.name == "dartls"
		and vim.lsp.document_color
		and client:supports_method("textDocument/documentColor")
	then
		vim.lsp.document_color.enable(true, { bufnr = event.buf }, { style = "background" })
	end
end

local function capabilities()
	return require("blink.cmp").get_lsp_capabilities()
end

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"prettierd",
				"gofumpt",
				"goimports",
				"eslint_d",
				"markdownlint-cli2",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"b0o/schemastore.nvim",
		},
		config = function()
			vim.lsp.log.set_level("warn")

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("theiskaa_lsp_attach", { clear = true }),
				callback = on_attach,
			})

			local schemastore = require("schemastore")
			servers.jsonls.settings = {
				json = { schemas = schemastore.json.schemas(), validate = { enable = true } },
			}
			servers.yamlls.settings = {
				yaml = {
					schemaStore = { enable = false, url = "" },
					schemas = schemastore.yaml.schemas(),
				},
			}

			vim.lsp.config("*", { capabilities = capabilities() })
			for name, cfg in pairs(servers) do
				vim.lsp.config(name, cfg)
			end

			-- automatic_enable starts every mason package with an lspconfig entry
			-- (stylua, dcmls, ...). Dart is owned by flutter-tools.
			local names = vim.tbl_keys(servers)
			require("mason-lspconfig").setup({
				ensure_installed = names,
				automatic_enable = false,
			})
			vim.lsp.enable(names)
		end,
	},
	{ "b0o/schemastore.nvim", lazy = true },
	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = { "nvim-lua/plenary.nvim", "saghen/blink.cmp" },
		config = function()
			require("flutter-tools").setup({
				lsp = {
					capabilities = capabilities(),
					flags = { debounce_text_changes = 500 },
					settings = {
						showTodos = true,
						renameFilesWithClasses = "prompt",
						updateImportsOnRename = true,
						completeFunctionCalls = false,
						lineLength = 100,
						enableSnippets = true,
						enableSdkFormatter = true,
					},
				},
				-- Needs nvim-dap, which isn't installed.
				debugger = { enabled = false, run_via_dap = false },
				outline = { auto_open = false },
				decorations = {
					statusline = { device = true, app_version = true },
				},
				widget_guides = { enabled = true, debug = false },
				dev_log = { enabled = false, open_cmd = "tabedit" },
			})
		end,
	},
}
