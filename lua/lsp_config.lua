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
local plugins = require('plugin_manager')

for _, plugin in pairs(langs.extra_plugins()) do
    plugins.setup(plugin)
end

function M.config()
    local mason = require('mason')
    local mason_installer = require('mason-tool-installer')
    local mason_lsp = require('mason-lspconfig')
    local lspconfig = require('lspconfig')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    mason.setup()
    mason_installer.setup({ ensure_installed = langs.ensure_installed() })

    mason_lsp.setup({
        handlers = {
            function(lang)
                local server = langs[lang] or {}
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
        callback = function(event)
            keymaps.lsp(event.buf)
        end,
    })
end

return M
