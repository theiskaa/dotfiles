local builtin = require('telescope.builtin')

-- Build/dependency output dirs to exclude from find & grep (dotfiles still shown).
local excluded_dirs = { '.git', 'build', '.fvm', '.dart_tool', 'target', '.next', '.open-next' }

local rg_excludes = {}
for _, dir in ipairs(excluded_dirs) do
  table.insert(rg_excludes, '--glob=!' .. dir .. '/')
end

local function rg_args()
  return vim.list_extend({ '--hidden', '--no-ignore' }, vim.deepcopy(rg_excludes))
end

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      '%.git/', 'build/', '%.fvm/', '%.dart_tool/', 'target/', '%.next/', '%.open%-next/',
    },
    vimgrep_arguments = vim.list_extend({
      'rg', '--color=never', '--no-heading', '--with-filename',
      '--line-number', '--column', '--smart-case',
      '--hidden', '--no-ignore',
    }, vim.deepcopy(rg_excludes)),
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = true,
      find_command = vim.list_extend(
        { 'rg', '--files', '--color=never', '--hidden', '--no-ignore' },
        vim.deepcopy(rg_excludes)
      ),
    },
    live_grep  = { additional_args = rg_args },
    grep_string = { additional_args = rg_args },
  },
})

vim.keymap.set('n', '<C-f>',  builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<C-w>',  builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<C-g>',  builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<C-d>',  builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<C-b>',  builtin.buffers, { desc = '[S]earch [B]uffers' })

-- Same keymap implementations of leader key:
vim.keymap.set('n', '<leader>f',  builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>h',  builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>w',  builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>g',  builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>d',  builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>?',  builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>',  builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

