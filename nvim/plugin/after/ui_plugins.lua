-- Lualine status line
local lualine_ok, lualine = pcall(require, 'lualine')
if lualine_ok then
  lualine.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
end


-- Notify setup
local notify_ok, notify = pcall(require, "notify")
if notify_ok then
  notify.setup({
    background_colour = "#000000",
    fps = 30,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "default",
    stages = "fade_in_slide_out",
    timeout = 5000,
    top_down = true
  })
end

-- Dressing for better UI
local dressing_ok, dressing = pcall(require, 'dressing')
if dressing_ok then
  dressing.setup({
    input = {
      enabled = true,
      default_prompt = "Input:",
      prompt_align = "left",
      insert_only = true,
      start_in_insert = true,
      border = "rounded",
      relative = "cursor",
      prefer_width = 40,
      width = nil,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },
      buf_options = {},
      win_options = {
        winblend = 10,
        wrap = false,
        list = true,
        listchars = "precedes:…,extends:…",
        sidescrolloff = 0,
      },
    },
    select = {
      enabled = true,
      backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
      trim_prompt = true,
      telescope = nil,
      fzf = {
        window = {
          width = 0.5,
          height = 0.4,
        },
      },
      fzf_lua = {},
      nui = {
        position = "50%",
        size = nil,
        relative = "editor",
        border = {
          style = "rounded",
        },
        buf_options = {
          swapfile = false,
          filetype = "DressingSelect",
        },
        win_options = {
          winblend = 10,
        },
        max_width = 80,
        max_height = 40,
        min_width = 40,
        min_height = 10,
      },
      builtin = {
        show_numbers = true,
        border = "rounded",
        relative = "editor",
        buf_options = {},
        win_options = {
          winblend = 10,
          cursorline = true,
          cursorlineopt = "both",
        },
        width = nil,
        max_width = { 140, 0.8 },
        min_width = { 40, 0.2 },
        height = nil,
        max_height = 0.9,
        min_height = { 10, 0.2 },
      },
    },
  })
end


-- Which Key setup
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.setup({
    preset = "modern",
    delay = 300,
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    sort = { "local", "order", "group", "alphanum", "mod" },
    expand = 1,
    replace = {
      key = {
        function(key)
          return require("which-key.view").format(key)
        end,
      },
    },
  })
end



-- Indent blankline
local ibl_ok, ibl = pcall(require, "ibl")
if ibl_ok then
  ibl.setup {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  }
end

-- Colorizer
local colorizer_ok, colorizer = pcall(require, 'colorizer')
if colorizer_ok then
  colorizer.setup()
end

-- Illuminate
local illuminate_ok, illuminate = pcall(require, 'illuminate')
if illuminate_ok then
  illuminate.configure({
    providers = {
      'lsp',
      'treesitter',
      'regex',
    },
    delay = 100,
    filetypes_denylist = {
      'dirvish',
      'fugitive',
    },
    filetypes_allowlist = {},
    modes_denylist = {},
    modes_allowlist = {},
    providers_regex_syntax_denylist = {},
    providers_regex_syntax_allowlist = {},
    under_cursor = true,
    large_file_cutoff = nil,
    large_file_overrides = nil,
    min_count_to_highlight = 1,
  })
end

-- Better quickfix
local bqf_ok, bqf = pcall(require, 'bqf')
if bqf_ok then
  bqf.setup({
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      win_height = 12,
      win_vheight = 12,
      delay_syntax = 80,
      border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
      should_preview_cb = function(bufnr, qwinid)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          ret = false
        end
        return ret
      end
    },
    func_map = {
      drop = 'o',
      openc = 'O',
      split = '<C-s>',
      tabdrop = '<C-t>',
      tabc = '',
      ptogglemode = 'z,',
    },
    filter = {
      fzf = {
        action_for = {['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop'},
        extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
      }
    }
  })
end

-- Window picker
local window_picker_ok, window_picker = pcall(require, 'window-picker')
if window_picker_ok then
  window_picker.setup({
    filter_rules = {
      include_current_win = false,
      autoselect_one = true,
      bo = {
        filetype = { 'neo-tree', "neo-tree-popup", "notify" },
        buftype = { 'terminal', "quickfix" },
      },
    },
    highlights = {
      statusline = {
        focused = {
          fg = '#ededed',
          bg = '#e35e4f',
          bold = true,
        },
        unfocused = {
          fg = '#ededed',
          bg = '#44cc41',
          bold = true,
        },
      },
      winbar = {
        focused = {
          fg = '#ededed',
          bg = '#e35e4f',
          bold = true,
        },
        unfocused = {
          fg = '#ededed',
          bg = '#44cc41',
          bold = true,
        },
      },
    },
  })
end