return {
    extra_settings = function()
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
