-- NOTE: the goal here is to configure everything related to a lang in a single file:
--       the lsp config, treesitter, formatters and extra plugins
--       so in each file you will find props with a 'extra_' prefix
--       this is a custom prop used only on this config, this is not canonical

return {
    lua_ls = require('langs.lua'),
    rust_analyzer = require('langs.rust'),
    lemminx = require('langs.xml'),
    tsserver = require('langs.js'),
    html = require('langs.html'),
}
