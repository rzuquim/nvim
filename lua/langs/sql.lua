return {
    extra_formatters = {
        sql = {
            {
                'sql-formatter',
                config = function()
                    return {
                        command = 'sql-formatter',
                        args = {
                            '-c',
                            -- TODO: infer the dialect
                            vim.fn.expand('~/.config/nvim/configs/tsql-formatter.json'),
                        },
                        stdin = true,
                    }
                end,
            },
        },
    },
    extra_treesitter = {
        'sql',
    },
}
