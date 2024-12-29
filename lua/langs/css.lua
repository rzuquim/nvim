local M = {}

M.css = {
    settings = {
        css = {
            lint = {
                unknownAtRules = 'ignore',
            },
        },
    },
    on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    extra_treesitter = {
        'css',
        'scss',
    },
    extra_formatters = {
        css = { 'prettier' },
        scss = { 'prettier' },
    },
}

M.tailwind = {
    extra_plugins = {
        {
            'luckasRanarison/tailwind-tools.nvim',
            build = ':UpdateRemotePlugins',
            config = function()
                require('tailwind-tools').setup({
                    conceal = {
                        enabled = true,
                    },
                })
            end,
        },
    },
}

return M
