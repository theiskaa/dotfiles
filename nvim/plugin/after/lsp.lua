local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	vim.notify("mason not found", vim.log.levels.ERROR)
	return
end

vim.lsp.set_log_level("warn")

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
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
	group = vim.api.nvim_create_augroup("theiskaa-lsp-attach", {}),
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }

		-- Navigation
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

		-- Diagnostics
		vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

		-- Code actions
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

		-- Workspace / symbols
		vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>cs", vim.lsp.buf.document_symbol, opts)

		-- Format (via conform if present, else LSP)
		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			local conform_ok, conform = pcall(require, "conform")
			if conform_ok then
				conform.format({ async = true, lsp_format = "fallback" })
			else
				vim.lsp.buf.format({ async = true })
			end
		end, opts)
	end,
})

mason.setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Auto-install formatters + linters (servers are handled by mason-lspconfig)
local mti_ok, mti = pcall(require, "mason-tool-installer")
if mti_ok then
	mti.setup({
		-- Pure formatters (conform) + linters (nvim-lint). LSP servers (incl.
		-- ruff) are handled by mason-lspconfig. ruff's binary is the same package.
		ensure_installed = {
			-- formatters
			"stylua",
			"prettierd",
			"gofumpt",
			"goimports",
			-- linters
			"eslint_d",
			"markdownlint-cli2",
		},
	})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
	capabilities = blink.get_lsp_capabilities(capabilities)
end
vim.lsp.config("*", { capabilities = capabilities })

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
				diagnostics = { globals = { "vim" } },
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
					-- fieldalignment removed in gopls v0.17.0
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
				analysis = {
					typeCheckingMode = "basic",
				},
			},
		},
	},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
				checkOnSave = true,
				check = { command = "clippy" },
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
	-- Python linter/formatter LSP (LazyVim pairs ruff with pyright). pyright
	-- owns hover/types/completion; ruff owns lint diagnostics + code actions.
	ruff = {},
}

for name, cfg in pairs(servers) do
	vim.lsp.config(name, cfg)
end

local enabled_servers = vim.tbl_keys(servers)

-- mason-lspconfig installs the servers. We DON'T use automatic_enable: it would
-- enable every mason-installed package that happens to ship an lspconfig entry
-- (e.g. stylua --lsp, or dcmls for Dart) and start unwanted/duplicate clients.
-- Instead we enable exactly the servers above. Dart is owned by flutter-tools.
require("mason-lspconfig").setup({
	ensure_installed = enabled_servers,
	automatic_enable = false,
})

vim.lsp.enable(enabled_servers)

local flutter_tools_ok, flutter_tools = pcall(require, "flutter-tools")
if flutter_tools_ok then
	flutter_tools.setup({
		lsp = {
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 500,
			},
			color = {
				enabled = true,
				background = true,
				virtual_text = false,
			},
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
		debugger = {
			enabled = true,
			run_via_dap = true,
			exception_breakpoints = {},
		},
		outline = { auto_open = false },
		decorations = {
			statusline = { device = true, app_version = true },
		},
		widget_guides = { enabled = true, debug = false },
		dev_log = { enabled = false, open_cmd = "tabedit" },
	})
else
	vim.notify("flutter-tools not found - Dart/Flutter LSP will not be available", vim.log.levels.WARN)
end
