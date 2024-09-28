return {
    extra_settings = function()
        local schemas = require('schemastore').json.schemas({ filename = '*.toml' })
        return {
            settings = {
                schema = {
                    disableGitIgnore = true,
                    associations = {
                        ['*.toml'] = schemas,
                    },
                },
            },
        }
    end,
    extra_treesitter = {
        'toml',
    },
}
