-- Port of LazyVim's linting setup, for linters no LSP covers.
local M = {}

local opts = {
	events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	linters_by_ft = {
		javascript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescript = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		markdown = { "markdownlint-cli2" },
	},
	linters = {
		eslint_d = {
			condition = function(ctx)
				return vim.fs.find({
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					".eslintrc.yml",
					".eslintrc.yaml",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts",
				}, { path = ctx.dirname, upward = true })[1] ~= nil
			end,
		},
		-- Over stdin it can't discover a config file, so pass ours explicitly.
		["markdownlint-cli2"] = {
			args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.jsonc", "-" },
		},
	},
}

local function debounce(ms, fn)
	local timer = assert(vim.uv.new_timer())
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

function M.setup()
	local lint = require("lint")

	for name, linter in pairs(opts.linters) do
		if type(linter) == "table" and type(lint.linters[name]) == "table" then
			lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
			if type(linter.prepend_args) == "table" then
				lint.linters[name].args = lint.linters[name].args or {}
				vim.list_extend(lint.linters[name].args, linter.prepend_args)
			end
		else
			lint.linters[name] = linter
		end
	end
	lint.linters_by_ft = opts.linters_by_ft

	local function run()
		local names = vim.list_extend({}, lint._resolve_linter_by_ft(vim.bo.filetype))
		if #names == 0 then
			vim.list_extend(names, lint.linters_by_ft["_"] or {})
		end
		vim.list_extend(names, lint.linters_by_ft["*"] or {})
		local ctx = { filename = vim.api.nvim_buf_get_name(0) }
		ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
		names = vim.tbl_filter(function(name)
			local linter = lint.linters[name]
			if not linter then
				vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
			end
			return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
		end, names)
		if #names > 0 then
			lint.try_lint(names)
		end
	end

	vim.api.nvim_create_autocmd(opts.events, {
		group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
		callback = debounce(100, run),
	})
	-- The plugin loads on BufReadPost, after that event already fired.
	run()
end

return M
