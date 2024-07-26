return {
    settings = {
        Lua = {
            completion = {
                callSnippet = 'Replace',
            },
        },
    },
    extra_formatters = {
        lua = { 'stylua' },
    },
}
