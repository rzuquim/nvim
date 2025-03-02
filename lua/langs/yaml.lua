return {
    extra_settings = function()
        local schemas = require('schemastore').yaml.schemas()
        return {
            init_options = {
                provideFormatter = false,
            },
            settings = {
                yaml = {
                    schemas = schemas,
                    validate = { enable = true },
                },
            },
        }
    end,
    extra_formatters = {
        yaml = { 'prettier' },
        yml = { 'prettier' },
    },
    extra_treesitter = {
        'yaml',
    }
}
