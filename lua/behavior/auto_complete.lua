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
    local compare = require('cmp.config.compare')
    local keymaps = require('keymaps')

    local kind_sort_score = {
        [cmp.lsp.CompletionItemKind.Field] = 1,
        [cmp.lsp.CompletionItemKind.Method] = 2,
        [cmp.lsp.CompletionItemKind.Function] = 3,
    }

    cmp.setup({
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = keymaps.cmp(cmp),
        sources = {
            { name = 'path', priority = 10 },
            { name = 'nvim_lsp', priority = 8 },
            { name = 'buffer', keyword_length = 3, priority = 1 },
        },
        formatting = {
            expandable_indicator = true,
            fields = { 'kind', 'abbr', 'menu' },
            format = function(entry, vim_item)
                vim_item.kind = string.format('%s', icons.kind[vim_item.kind])

                vim_item.menu = ({
                    nvim_lsp = '[LSP]',
                    buffer = '[Buffer]',
                    path = '[Path]',
                })[entry.source.name]
                return vim_item
            end,
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.exact,
                compare.locality,
                compare.recently_used,
                function(entry1, entry2)
                    local kind1 = entry1:get_kind()
                    local kind2 = entry2:get_kind()

                    local score1 = kind_sort_score[kind1] or 99
                    local score2 = kind_sort_score[kind2] or 99

                    if score1 ~= score2 then
                        return score1 < score2
                    end
                end,
                cmp.config.compare.score,
                compare.sort_text,
            },
        },
    })
end

return M
