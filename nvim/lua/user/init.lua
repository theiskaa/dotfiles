local config = {
  colorscheme = "gruvbox",

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

  plugins = {
    init = {
      { "morhetz/gruvbox" },
      { "dart-lang/dart-vim-plugin" },
      { "thosakwe/vim-flutter" },
      { "fatih/vim-go" },
    },
    -- All other entries override the setup() call for default plugins
    treesitter = {
      ensure_installed = { "lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
  },

  -- Add paths for including more VS Code style snippets in luasnip
  luasnip = {
    vscode_snippet_paths = {},
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings to the normal mode <leader> mappings
    register_n_leader = {
      -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- null-ls configuration
  ["null-ls"] = function()
    -- Formatting and linting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    local status_ok, null_ls = pcall(require, "null-ls")
    if not status_ok then
      return
    end

    -- Check supported formatters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting

    -- Check supported linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup {
      debug = false,
      sources = {
        -- Set a formatter
        formatting.rufo,
        -- Set a linter
        diagnostics.rubocop,
      },
      -- NOTE: You can remove this on attach function to disable format on save
      on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
          vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
        end
      end,
    }
  end,

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    local opts = { noremap = true, silent = true }
    local map = vim.api.nvim_set_keymap
    local set = vim.opt

    -- Set options
    set.relativenumber = true

    -- Set key bindings
    map("n", "<C-s>", ":w!<CR>", opts)
    map("n", "<C-s>", ":w!<CR>", opts)
    map("n", "fd", ":DartFmt<CR>", opts)
    map("n", "<CR>", ":nohlsearch<CR>", opts)
    map("n", "fsv", ":vs<CR>", opts)
    map("n", "fsh", ":split horizontal<CR>", opts)
    map("n", ",fa", ":FlutterRun<CR>", opts)
    map("n", ",fr", ":FlutterHotReload<CR>", opts)
    map("n", ",fR", ":FlutterHotRestart<CR>", opts)
    map("n", ",fq", ":FlutterQuit<CR>", opts)
    map("n", "<cmd>W", ":w!<CR>", opts)

    -- Set transparency = ON.
    vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi CursorColumn cterm=NONE ctermbg=NONE ctermfg=NONE")
    vim.cmd("hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE")
    vim.cmd("hi CursorLineNr cterm=NONE ctermbg=NONE ctermbg=NONE")
    vim.cmd("hi clear LineNr")
    vim.cmd("hi clear SignColumn")
    vim.cmd("hi clear StatusLine")

    -- Set custom command key-maps
    vim.cmd [[
      command! Q :q
      command! W :w
      command! Wq :wq
      command! WQ :wq
    ]]

    -- Set autocommands
    vim.cmd [[
      augroup packer_conf
        autocmd!
        autocmd bufwritepost plugins.lua source <afile> | PackerSync
      augroup end
    ]]
  end,
}

return config
