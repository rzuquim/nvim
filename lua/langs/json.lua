return {
    extra_settings = function()
        local schemas = require('schemastore').json.schemas({
            select = {
                'package.json',
                'tsconfig.json',
                'babelrc.json',
                '.eslintrc',
                'prettierrc.json',
                'launchsettings.json',
                '.vsconfig',
            },
        })
        return {
            settings = {
                json = {
                    schemas = schemas,
                    validate = { enable = true },
                },
            },
        }
    end,
    extra_formatters = {
        json = { 'prettier' },
    },
    extra_treesitter = {
        'json',
    },
}
