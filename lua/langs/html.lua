local M = {}

M.html = {
    settings = {},
    extra_formatters = {
        html = { 'prettier' },
    },
    extra_treesitter = {
        'html',
    },
}

M.emmet = {
    settings = {
        filetypes = {
            'html',
            'javascriptreact',
            'typescriptreact',
        },
        init_options = {
            html = {
                options = {
                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                    ['bem.enabled'] = true,
                },
            },
        },
    },
}

return M
