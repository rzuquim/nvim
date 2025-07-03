return function(luasnip)
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node

    return {
        s('docs', {
            t('/// <summary>'),
            t({ '', '/// ' }),
            i(1, 'docs goes here'),
            t({ '', '/// </summary>' }),
            t({ '', '/// <remarks>' }),
            t('</remarks>'),
        }),
        s('idocs', { t('/// <inheritdoc cref="'), i(1, 'ref'), t('" />') }),
        s('idocs!', t('/// <inheritdoc/>')),
    }
end
