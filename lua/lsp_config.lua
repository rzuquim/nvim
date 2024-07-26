local M = {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true }, -- package manager
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} }, -- pretty loading
        { 'folke/neodev.nvim', opts = {} }, -- lua, lsp and vim types
        'nvim-lua/plenary.nvim',
    },
}

local langs = require('langs')
local ensure_installed = {}

function M.config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    require('mason').setup()
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    require('mason-lspconfig').setup({
        handlers = {
            function(lang)
                local server = langs[lang] or {}
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require('lspconfig')[lang].setup(server)
            end,
        },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('keymaps-lsp-attach', { clear = true }),
        callback = function(event)
            KEYMAPS.lsp(event.buf)
        end,
    })
end

for lang, settings in pairs(langs) do
    table.insert(ensure_installed, lang)

    if settings.extra_formatters then
        for _, formattersByFileType in pairs(settings.extra_formatters) do
            for _, formatter in ipairs(formattersByFileType) do
                table.insert(ensure_installed, formatter)
            end
        end
    end
end

return M
