local keymaps = require('keymaps')

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
        'hrsh7th/cmp-buffer',
    },
}

local icons = require('appearance.icons')

function M.config()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local vscode_snippets = require('luasnip/loaders/from_vscode')
    local langs = require('langs')

    luasnip.config.setup({})

    for ft, snippets_fns in pairs(langs.extra_snippets()) do
        for _, fn in ipairs(snippets_fns) do
            luasnip.add_snippets(ft, fn(luasnip))
        end
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = keymaps.cmp(cmp, luasnip),
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer', keyword_length = 3 },
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

    vscode_snippets.lazy_load()
    luasnip.filetype_extend('typescriptreact', { 'html' })
end

return M
