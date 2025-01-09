return {
    extra_settings = function()
        -- NOTE: avoiding plugins to conceal the " on json files
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'json',
            command = 'setlocal conceallevel=0',
            group = vim.api.nvim_create_augroup('json_conceal', { clear = true }),
        })

        local schemas = require('schemastore').json.schemas()
        return {
            init_options = {
                provideFormatter = false,
            },
            settings = {
                json = {
                    -- BUG: schemas not working
                    schemas = schemas,
                    validate = { enable = true },
                },
            },
        }
    end,
    extra_formatters = {
        json = { 'prettier' },
        jsonc = { 'prettier' },
    },
    extra_treesitter = {
        'json',
    },
}
