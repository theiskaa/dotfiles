vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neo-tree").setup({
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  open_files_do_not_replace_types = { "terminal", "trouble", "qf" },

  -- Scope `git status` to the directory being browsed rather than the whole
  -- worktree root.
  git_status_scope_to_path = true,

  event_handlers = {
    {
      -- neo-tree asks git to enumerate every *ignored* file
      -- (`--ignored=traditional`, see neo-tree/git/init.lua). In a Rust repo
      -- that means walking all of target/ on every refresh: measured at ~28-31s
      -- on hedos, warm cache, to produce 14 lines of output. `--ignored=no`
      -- returns the same useful result in ~0.03s.
      --
      -- Safe here because filtered_items.hide_gitignored is false (nothing is
      -- filtered on this data) and the expensive trees -- target, build,
      -- .dart_tool, .next -- are already in never_show.
      event = "before_git_status",
      handler = function(args)
        local cmd = args and args.status_args
        if type(cmd) ~= "table" then
          return
        end
        for i, arg in ipairs(cmd) do
          if arg == "--ignored=traditional" then
            cmd[i] = "--ignored=no"
          end
        end
      end,
    },
  },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    hijack_netrw_behavior = "disabled",
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
      -- Build/dependency output: hidden even though everything else is visible.
      never_show = {
        "build",
        ".fvm",
        ".dart_tool",
        "target",
        ".next",
        ".open-next",
      },
    },
  },
  window = {
    mappings = {
      ["<space>"] = "none",
      ["w"] = "none",
      ["Y"] = {
        function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.setreg("+", path, "c")
        end,
        desc = "Copy Path to Clipboard",
      },
      ["O"] = {
        function(state)
          require("lazy.util").open(state.tree:get_node().path, { system = true })
        end,
        desc = "Open with System Application",
      },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
  },
})

-- Refresh the git_status source when a terminal opens, debounced: opening a
-- burst of terminals used to fire one `git status` per terminal, and each of
-- those could outlive the editor.
local git_refresh_timer = nil
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if not package.loaded["neo-tree.sources.git_status"] then
      return
    end
    if git_refresh_timer and not git_refresh_timer:is_closing() then
      git_refresh_timer:stop()
      git_refresh_timer:close()
    end
    git_refresh_timer = vim.defer_fn(function()
      git_refresh_timer = nil
      pcall(function()
        require("neo-tree.sources.git_status").refresh()
      end)
    end, 250)
  end,
})
