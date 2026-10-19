-- Set before lazy.nvim so plugin keys pick up the leader.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2"

opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true
opt.breakindentopt = "shift:2"

opt.wrap = false
opt.textwidth = 100
opt.showbreak = "↪ "

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.undolevels = 10000
opt.confirm = true
opt.shada = "'100,<50,s10,h,/100,:100"
opt.shadafile = vim.fn.stdpath("state") .. "/shada/main.shada"
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"

opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"

opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.colorcolumn = "+1" -- one past textwidth (100)
opt.laststatus = 3
opt.ruler = false
opt.showmode = false
opt.cursorline = true
opt.cursorlineopt = "both"
opt.showtabline = 0
opt.conceallevel = 2
opt.concealcursor = ""
opt.pumblend = 10
opt.pumheight = 10
opt.winblend = 10
opt.smoothscroll = true
opt.synmaxcol = 500
opt.redrawtime = 1500
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.jumpoptions = "view"
opt.virtualedit = "block"
opt.isfname:append("@-@")

-- Lower values fire CursorHold constantly and keep plugins busy while idle.
opt.updatetime = 200

opt.mouse = "a"
opt.completeopt = "menu,menuone,noselect"

-- Probing the clipboard provider is slow, so defer it past startup.
vim.schedule(function()
	opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)
