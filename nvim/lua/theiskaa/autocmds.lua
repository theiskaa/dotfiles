local function augroup(name)
	return vim.api.nvim_create_augroup("theiskaa_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 41 })
	end,
})

autocmd("BufWritePre", {
	group = augroup("trim_whitespace"),
	callback = function(event)
		if not vim.bo[event.buf].modifiable or vim.bo[event.buf].binary then
			return
		end
		local view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc_done then
			return
		end
		vim.b[buf].last_loc_done = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"checkhealth",
		"help",
		"lspinfo",
		"qf",
		"startuptime",
		"gitsigns-blame",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", function()
			vim.cmd("close")
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
	end,
})

autocmd("FileType", {
	group = augroup("spell"),
	pattern = { "markdown", "gitcommit", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en"
	end,
})

autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
