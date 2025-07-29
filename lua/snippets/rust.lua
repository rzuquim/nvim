return function(luasnip)
    local bevy_snippets = require('snippets.rust_bevy')
    local tauri_snippets = require('snippets.rust_tauri')

    return vim.list_extend(bevy_snippets(luasnip), tauri_snippets(luasnip))
end
