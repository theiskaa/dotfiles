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

-- Beautiful text rendering (like Helix)
-- Conceal settings for better text display
vim.o.conceallevel = 2
vim.o.concealcursor = ""

-- Better popup menu rendering
vim.o.pumblend = 10  -- Transparency for popup menu
vim.o.pumheight = 10  -- Maximum number of items in popup menu

-- Better floating window rendering
vim.o.winblend = 10  -- Transparency for floating windows

-- Smooth scrolling (if supported)
vim.o.smoothscroll = true

-- Better line wrapping display
vim.o.showbreak = "↪ "
vim.o.breakindentopt = "shift:2"

-- Better number column display
vim.opt.numberwidth = 4

-- Better syntax highlighting
vim.o.synmaxcol = 500  -- Don't syntax highlight very long lines (improves performance)

-- Better rendering performance
vim.o.redrawtime = 1500  -- Time in milliseconds for redrawing the display
vim.o.lazyredraw = false  -- Don't use lazy redraw (can cause rendering issues)

-- Better cursor rendering
vim.o.cursorlineopt = "both"  -- Highlight both line and number column

-- System interaction
vim.o.mouse = 'a' -- Enable mouse mode
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- File tree configuration (for nvim-tree.lua)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Completion experience
vim.o.completeopt = 'menuone,noselect'
