local M = {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                'rafamadriz/friendly-snippets', -- NOTE: a bunch of common snippets
            },
        },
        'saadparwaiz1/cmp_luasnip',

        --  nvim-cmp does not ship with all sources by default
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
    },
}

local icons = require('appearance.icons')

function M.config()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.config.setup({})

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert(KEYMAPS.cmp(cmp, luasnip)),
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer' },
        },
        formatting = {
            expandable_indicator = true,
            fields = { 'kind', 'abbr', 'menu' },
            format = function(entry, vim_item)
                vim_item.kind = string.format('%s', icons.kind[vim_item.kind])

                vim_item.menu = ({
                    nvim_lsp = '[LSP]',
                    luasnip = '[Snippet]',
                    buffer = '[Buffer]',
                    path = '[Path]',
                })[entry.source.name]
                return vim_item
            end,
        },
    })

    require('luasnip/loaders/from_vscode').lazy_load()
    require('luasnip').filetype_extend('typescriptreact', { 'html' })
end

return M
