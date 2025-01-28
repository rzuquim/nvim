local M = {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        -- NOTE: nvim-cmp does not ship with all sources by default
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
    },
}

local icons = require('appearance.icons')

function M.config()
    local cmp = require('cmp')
    local keymaps = require('keymaps')

    cmp.setup({
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = keymaps.cmp(cmp),
        sources = {
            { name = 'nvim_lsp' },
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
end

return M
