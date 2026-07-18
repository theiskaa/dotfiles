-- Treesitter Configuration
-- Advanced syntax highlighting and code analysis

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c", "lua", "rust", "go",
    "javascript", "typescript", "html", "css", "json",
    "dart",
    "vim", "markdown", "bash"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- Consistent text highlighting
  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  -- Code indentation based on syntax
  indent = {
    enable = true
  },

  -- Incremental selection based on syntax tree
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- Neovim 0.12 compat shim.
--
-- On Neovim 0.11+, a query match maps each capture to a *list* of nodes
-- (`table<integer, TSNode[]>`), but nvim-treesitter's (deprecated) master branch
-- still treats `match[id]` as a single node in its injection directives. That
-- makes it pass the list into `get_node_text`, which calls `:range()` on a table
-- and crashes with "attempt to call method 'range' (a nil value)" -- e.g. on
-- every markdown buffer containing a fenced code block.
--
-- We re-register the three affected directives (force=true) to unwrap the node
-- list first. Remove this once nvim-treesitter is migrated to the `main` branch,
-- which handles the list API natively.
local ts_query_ok, ts_query = pcall(require, "vim.treesitter.query")
if ts_query_ok then
  -- match[id] may be a single node (old API) or a list of nodes (0.11+).
  local function node_of(match, id)
    local v = match[id]
    if type(v) == "table" then
      return v[#v]
    end
    return v
  end

  local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
  }

  local info_string_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    uxn = "uxntal",
    ts = "typescript",
  }

  ts_query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = node_of(match, pred[2])
    if not node then
      return
    end
    local value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, { force = true, all = false })

  ts_query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = node_of(match, pred[2])
    if not node then
      return
    end
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    local ft = vim.filetype.match({ filename = "a." .. alias })
    metadata["injection.language"] = ft or info_string_aliases[alias] or alias
  end, { force = true, all = false })

  ts_query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = node_of(match, id)
    if not node then
      return
    end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
      metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
  end, { force = true, all = false })
end
