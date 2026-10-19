local map = vim.keymap.set

vim.cmd([[command! W :w]])
vim.cmd([[command! Q :q]])
vim.cmd([[command! Wq :wq]])
vim.cmd([[command! WQ :wq]])

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
map(
	"n",
	"<leader>rn",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Rename word under cursor in file" }
)

local function format()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" })
	else
		vim.lsp.buf.format({ async = true })
	end
end
map("n", "df", format, { desc = "Format document" })
map({ "n", "v" }, "<leader>cf", format, { desc = "Format" })

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

map("n", "<S-h>", "<cmd>bprevious<CR>", { silent = true, desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { silent = true, desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete other buffers" })

map("n", "fsv", ":vs<CR>", { silent = true, desc = "Split vertically" })
map("n", "fsh", ":split<CR>", { silent = true, desc = "Split horizontally" })

-- Old nvim-treesitter keys mapped to Neovim's built-in `an`/`in` selection.
map("n", "gnn", "van", { remap = true, desc = "Start incremental selection" })
map("x", "grn", "an", { remap = true, desc = "Grow selection" })
map("x", "grm", "in", { remap = true, desc = "Shrink selection" })

map("n", "Q", "<nop>", { desc = "Disable Ex mode" })

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" })
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })

map("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open({ command = "topleft 30vnew" })
end, { desc = "Toggle undo tree" })

map("n", "<leader>G", function()
	Snacks.lazygit()
end, { silent = true, desc = "Open lazygit" })
