vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'f4z3r/gruvbox-material.nvim'
  use({ 'ellisonleao/gruvbox.nvim', as = 'gruvbox' })
  use 'Yazeed1s/minimal.nvim'
  use 'huyvohcmc/atlas.vim'
  use 'Mofiqul/vscode.nvim'

  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup { icons = false }
      end
  })

  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})
  use "nvim-treesitter/playground"
  use "theprimeagen/harpoon"
  use "theprimeagen/refactoring.nvim"
  use "mbbill/undotree"
  use "nvim-treesitter/nvim-treesitter-context"

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},
		  {'neovim/nvim-lspconfig'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }

  use "folke/zen-mode.nvim"
  use "github/copilot.vim"
  use "eandrju/cellular-automaton.nvim"
  use "laytan/cloak.nvim"
  use 'xiyaowong/nvim-transparent'
  use "sindrets/diffview.nvim"

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    tag = 'nightly'
  }

  use "windwp/nvim-autopairs" -- Auto Pairs (configured in lsp.lua)

  use 'fatih/vim-go'
  use 'dart-lang/dart-vim-plugin'
  use {
    "akinsho/flutter-tools.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
       require('flutter-tools').setup({
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
          dev_log = { enabled = false, open_cmd = 'tabedit' },
          lsp = {
            color = {
              enabled = true,
              background = true,
              virtual_text = false,
            },
            settings = {
              showTodos = true,
              renameFilesWithClasses = 'prompt',
              updateImportsOnRename = true,
              completeFunctionCalls = true,
              lineLength = 100,
            },
          },
        })
    end,
    lazy = false,
    dev = true,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim',
    },
  }
end)
