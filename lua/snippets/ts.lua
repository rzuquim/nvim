return function(luasnip)
    local s = luasnip.snippet
    local i = luasnip.insert_node
    local fmt = require('luasnip.extras.fmt').fmt

    return {
        s(
            'docs_fn',
            fmt(
                [[
/**
 * {description}
 * 
 * @function
 * @param {param} - {paramDescription}
 * @returns {returnDescription}
 * @throws {errorDescription}
 * @example
 * {exampleCode}
 */
]],
                {
                    description = i(1, 'description'),
                    param = i(2, 'param'),
                    paramDescription = i(3, 'param description'),
                    returnDescription = i(4, 'return description'),
                    errorDescription = i(5, 'error description'),
                    exampleCode = i(6, 'example code'),
                }
            )
        ),
    }
end
