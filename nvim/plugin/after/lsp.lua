-- Check if required plugins are available
local lsp_zero_ok, lsp = pcall(require, 'lsp-zero')
if not lsp_zero_ok then
    vim.notify("lsp-zero not found", vim.log.levels.ERROR)
    return
end

local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
    vim.notify("mason not found", vim.log.levels.ERROR)
    return
end

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
    vim.notify("nvim-cmp not found", vim.log.levels.ERROR)
    return
end

-- Configure LSP logging (reduce verbosity for performance)
vim.lsp.set_log_level('warn')

local notify = vim.notify
vim.notify = function(msg, level, opts)
    if type(msg) == "string" and msg:match("textDocument/didChange") and msg:match("dartls") then
        return
    end
    notify(msg, level, opts)
end

-- Configure diagnostic display
vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
    },
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- Enhanced LSP capabilities for autocompletion
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

-- Configure keybindings when an LSP is attached to a buffer
-- IMPORTANT: This must be defined BEFORE mason-lspconfig.setup!
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

    -- Diagnostics
    vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

    -- Code actions
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

    -- Workspace
    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)

    -- Format
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
    end, opts)

    -- Document symbols
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.document_symbol, opts)
end

mason.setup({
    ui = {
        border = 'rounded',
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- LSP server configurations
local servers = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library",
                        "${3rd}/busted/library",
                    }
                },
                completion = { callSnippet = "Replace" },
                diagnostics = { globals = { "vim" } },
                hint = { enable = true },
                telemetry = { enable = false },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                gofumpt = true,
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
            },
        },
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                },
            },
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = { command = "clippy" },
            },
        },
    },
    tsserver = {
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHints = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
}

-- Configure mason-lspconfig to install and setup LSP servers
require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
        function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.on_attach = on_attach
            require("lspconfig")[server_name].setup(server)
        end,
    },
})

-- ============================================================================
-- FLUTTER/DART SETUP
-- ============================================================================

-- Flutter-tools manages the Dart LSP server itself, so we configure it separately
local flutter_tools_ok, flutter_tools = pcall(require, 'flutter-tools')
if flutter_tools_ok then
    flutter_tools.setup({
        lsp = {
            on_attach = on_attach,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 500,
            },
            color = {
                enabled = true,
                background = true,
                virtual_text = false,
            },
            settings = {
                showTodos = true,
                renameFilesWithClasses = 'prompt',
                updateImportsOnRename = true,
                completeFunctionCalls = false,
                lineLength = 100,
                enableSnippets = true,
                enableSdkFormatter = true,
            },
        },
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
    })
else
    vim.notify("flutter-tools not found - Dart/Flutter LSP will not be available", vim.log.levels.WARN)
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if luasnip_ok then
    -- Load friendly-snippets
    local vscode_loader_ok, _ = pcall(require, 'luasnip.loaders.from_vscode')
    if vscode_loader_ok then
        require('luasnip.loaders.from_vscode').lazy_load()
    end
else
    vim.notify("LuaSnip not found", vim.log.levels.WARN)
end

cmp.setup({
    snippet = {
        expand = function(args)
            if luasnip_ok then
                luasnip.lsp_expand(args.body)
            end
        end,
    },
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
        documentation = {
            border = "rounded",
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
            }

            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip_ok and luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip_ok and luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
    }),
    experimental = {
        ghost_text = {
            hl_group = "CmpGhostText",
        },
    },
})

local autopairs_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if autopairs_ok then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    local autopairs_main_ok, autopairs = pcall(require, 'nvim-autopairs')
    if autopairs_main_ok then
        autopairs.setup({
            check_ts = true,
            ts_config = {
                lua = {'string','source'},
                javascript = {'string','template_string'},
                dart = {'string'},
            },
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            fast_wrap = {
                map = '<M-e>',
                chars = { '{', '[', '(', '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
                offset = 0,
                end_key = '$',
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                check_comma = true,
                highlight = 'PmenuSel',
                highlight_grey = 'LineNr'
            },
        })
    end
end
