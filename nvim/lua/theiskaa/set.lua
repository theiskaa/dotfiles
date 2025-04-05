-- Cursor appearance
vim.o.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2"

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.o.breakindent = true -- Enable break indent

-- Line wrapping
vim.opt.wrap = false
vim.o.textwidth = 100 -- Char per line

-- File management
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- ShaDa file configuration (prevents corruption issues)
vim.opt.shada = "'100,<50,s10,h,/100,:100"  -- More conservative ShaDa settings
vim.opt.shadafile = vim.fn.stdpath("state") .. "/shada/main.shada"
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true

-- UI appearance
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- System interaction
vim.o.mouse = 'a' -- Enable mouse mode
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- File tree configuration (for nvim-tree.lua)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Completion experience
vim.o.completeopt = 'menuone,noselect'
