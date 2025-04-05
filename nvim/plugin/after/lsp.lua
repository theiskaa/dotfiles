local lsp = require('lsp-zero')

-- Setup Mason for LSP server management
require('mason').setup({
    ui = {
        border = 'rounded',
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Configure which LSP servers to install
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'gopls',
        'pyright',
        'rust_analyzer',
        'ast_grep',
    },
    handlers = {
        lsp.default_setup,
    },
})

-- Apply recommended LSP settings
lsp.preset('recommended')

-- Configure LSP logging (avoid verbose logs in normal usage)
vim.lsp.set_log_level('warn')

-- Configure diagnostic display settings
vim.diagnostic.config({
    virtual_text = true,      -- Show diagnostics as virtual text
    signs = true,             -- Show signs in the sign column
    update_in_insert = false, -- Don't update diagnostics in insert mode
    underline = true,         -- Underline text with issues
    severity_sort = true,     -- Sort by severity
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- Performance related settings
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

-- Configure keybindings when an LSP is attached to a buffer
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- Go to definition and documentation
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

    -- Symbol and diagnostic navigation
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    -- Code actions and references
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

    -- Help while typing
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

-- Configure specific LSP servers
local lspconfig = require('lspconfig')

-- Lua LSP settings
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }, -- Recognize vim global in Neovim config
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

lsp.setup()
