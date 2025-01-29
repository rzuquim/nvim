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
 * @param {paramType} {param} - {paramDescription}
 * @returns {returnType} - {returnDescription}
 * @throws {errorType} - {errorDescription}
 * @example
 * {exampleCode}
 */
]],
                {
                    description = i(1, 'description'),
                    paramType = i(2, 'param type'),
                    param = i(3, 'param name'),
                    paramDescription = i(4, 'param description'),
                    returnType = i(5, 'return type'),
                    returnDescription = i(6, 'return description'),
                    errorType = i(7, 'error type'),
                    errorDescription = i(8, 'error description'),
                    exampleCode = i(9, 'example code'),
                }
            )
        ),
    }
end
