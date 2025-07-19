local M = {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true }, -- package manager
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} }, -- pretty loading
        { 'folke/neodev.nvim', opts = {} }, -- lua, lsp and vim types
        'nvim-lua/plenary.nvim',
        'b0o/schemastore.nvim',
    },
}

local langs = require('langs')
local keymaps = require('keymaps')

local function lsp_find_references()
    local telescope_builtin = require('telescope.builtin')
    telescope_builtin.lsp_references({
        include_declaration = false,
        include_current_line = false,
    })
end

local function with_border(handler)
    return function(config)
        config = config or {}
        config.border = 'rounded'
        return handler(config)
    end
end

function M.config()
    local mason = require('mason')
    local mason_installer = require('mason-tool-installer')
    local mason_lsp = require('mason-lspconfig')
    local lspconfig = require('lspconfig')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local icons = require('appearance.icons')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    -- NOTE: disabling snippets on cmp in favor of explicitly searching then
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    mason.setup()
    mason_installer.setup({ ensure_installed = langs.ensure_installed() })

    mason_lsp.setup({
        handlers = {
            function(lang)
                local server = langs[lang] or {}
                if server.disable_lsp then
                    return
                end

                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                if server.extra_settings then
                    lspconfig[lang].setup(server.extra_settings())
                else
                    lspconfig[lang].setup(server)
                end
            end,
        },
    })

    vim.lsp.buf.hover = with_border(vim.lsp.buf.hover)
    vim.lsp.buf.signature_help = with_border(vim.lsp.buf.signature_help)

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('keymaps-lsp-attach', { clear = true }),
        callback = function(evt)
            keymaps.lsp(evt.buf, lsp_find_references, langs)
        end,
    })

    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = icons.diagnostics.BoldError,
                [vim.diagnostic.severity.WARN] = icons.diagnostics.BoldWarning,
                [vim.diagnostic.severity.INFO] = icons.diagnostics.BoldInformation,
                [vim.diagnostic.severity.HINT] = icons.diagnostics.BoldHint,
            },
        },
    })
end

return M
