local M = {}

M.html = {
    settings = {},
    extra_formatters = {
        html = { 'prettier' },
    },
    extra_treesitter = {
        'html',
        'liquid',
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

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'html',
    callback = function()
        vim.api.nvim_buf_create_user_command(0, 'PreviewToggle', function()
            local util = require('util')
            util.toggle_preview()
        end, {})
    end,
})

return M
