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
                local cwd = vim.fn.getcwd()

                local config_files = {
                    'tailwind.config.js',
                }

                local uses_tailwind = false
                for _, filename in ipairs(config_files) do
                    local path = cwd .. '/' .. filename
                    if vim.loop.fs_stat(path) then
                        uses_tailwind = true
                    end
                end

                require('tailwind-tools').setup({
                    conceal = {
                        enabled = uses_tailwind,
                    },
                })
            end,
        },
    },
}

return M
