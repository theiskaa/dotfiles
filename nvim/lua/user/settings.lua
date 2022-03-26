local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
local set = vim.opt

local config = {
  colorscheme = "gruvbox",

  -- Add plugins
  plugins = {
    { "morhetz/gruvbox" },
    { "dart-lang/dart-vim-plugin" },
    { "thosakwe/vim-flutter" },
    { "fatih/vim-go" },
    -- ... --
  },

  overrides = {
    treesitter = {
      ensure_installed = { "lua" },
    },
  },

  -- On/off virtual diagnostics text
  virtual_text = true,

  -- Disable default plugins
  enabled = {
    bufferline = true,
    nvim_tree = true,
    lualine = true,
    lspsaga = true,
    gitsigns = true,
    colorizer = false,
    toggle_term = true,
    comment = true,
    symbols_outline = true,
    indent_blankline = false,
    dashboard = true,
    which_key = true,
    neoscroll = false,
    ts_rainbow = false,
    ts_autotag = false,
  },
}

-- Set key bindings
map("n", "<C-s>", ":w!<CR>", opts)

-- Set autocommands
vim.cmd [[
  augroup packer_conf
    autocmd!
    autocmd bufwritepost plugins.lua source <afile> | PackerSync
  augroup end
]]

return config
