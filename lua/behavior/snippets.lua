local M = {
    'L3MON4D3/LuaSnip',
    build = (function()
        return 'make install_jsregexp'
    end)(),
    event = 'VeryLazy',
    dependencies = {
        'rafamadriz/friendly-snippets',
        'saadparwaiz1/cmp_luasnip',
        'benfowler/telescope-luasnip.nvim',
    },
}

function M.config()
    local langs = require('langs')
    local luasnip = require('luasnip')
    local vscode_snippets = require('luasnip/loaders/from_vscode')
    local telescope = require('telescope')
    local keymaps = require('keymaps')
    local luasnip_types = require('luasnip.util.types')

    luasnip.config.setup({
        history = false,
        ext_opts = {
            [luasnip_types.choiceNode] = {
                active = {
                    virt_text = { { '󰄽', 'LuasnipChoiceNodeVirtualText' } },
                },
            },
            [luasnip_types.insertNode] = {
                active = {
                    virt_text = { { '󰄽', 'LuasnipInsertNodeVirtualText' } },
                },
            },
        },
    })

    vim.api.nvim_set_hl(0, 'LuasnipChoiceNodeVirtualText', { link = '@diff.minus' })
    vim.api.nvim_set_hl(0, 'LuasnipInsertNodeVirtualText', { link = '@diff.delta' })

    for ft, snippets_fns in pairs(langs.extra_snippets()) do
        for _, fn in ipairs(snippets_fns) do
            luasnip.add_snippets(ft, fn(luasnip))
        end
    end

    vscode_snippets.lazy_load()
    luasnip.filetype_extend('typescriptreact', { 'html' })
    telescope.load_extension('luasnip')
    keymaps.snippets({
        jump_forward = function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end,
        jump_back = function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end,
    })
end

return M
