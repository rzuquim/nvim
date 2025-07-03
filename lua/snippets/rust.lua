return function(luasnip)
    local bevy_snippets = require('snippets.rust_bevy')
    return vim.tbl_deep_extend('force', {}, bevy_snippets(luasnip))
end
