--[[return {
    lsp = "lualsp",
    tree_sitter = "",
    formatters = { "stylua" },
    snippets = {},
}]]

return {
    settings = {
        Lua = {
            completion = {
                callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
        },
    },
    -- NOTE: not an lsp cofig everything with a leading extra_ is a custom prop
    extra_formatters = {
        lua = { 'stylua' },
    },
}
