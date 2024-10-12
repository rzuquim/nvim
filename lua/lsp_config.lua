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

function M.config()
    local mason = require('mason')
    local mason_installer = require('mason-tool-installer')
    local mason_lsp = require('mason-lspconfig')
    local lspconfig = require('lspconfig')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local icons = require('appearance.icons')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

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

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('keymaps-lsp-attach', { clear = true }),
        callback = function(evt)
            keymaps.lsp(evt.buf)
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
