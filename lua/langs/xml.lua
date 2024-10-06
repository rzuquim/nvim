return {
    settings = {
        xml = {
            validation = {
                dtd = true,
                schema = true,
            },
            format = {
                -- TODO: disable when xmlformatter is working
                enabled = true,
            },
        },
    },
    -- TODO: enable when we can fix the error: 'xmlformatter unavailable: Formatter config missing or incomplete'
    -- extra_formatters = {
    --     xml = { 'xmlformatter' },
    --     config = { 'xmlformatter' },
    -- },
    extra_treesitter = {
        'xml',
    },
}
