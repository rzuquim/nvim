return {
    on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    extra_treesitter = {
        'css',
        'scss',
    },
    extra_formatters = {
        css = { 'prettierd' },
        scss = { 'prettierd' },
    },
}
