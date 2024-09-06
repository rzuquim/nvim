return {
    settings = {
        Lua = {
            completion = {
                callSnippet = 'Replace',
            },
            -- diagnostics = { disable = { 'missing-fields' } },
            format = {
                enable = false,
            },
            diagnostics = {
                globals = { 'vim', 'spec' },
            },
            runtime = {
                version = 'LuaJIT',
                special = {
                    spec = 'require',
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
            },
            telemetry = {
                enable = false,
            },
        },
    },
    extra_formatters = {
        -- Used to format Lua code
        lua = { 'stylua' },
    },
    extra_treesitter = {
        'lua',
        'luadoc',
        'vim',
    },
}
