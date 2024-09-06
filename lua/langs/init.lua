-- NOTE: the goal here is to configure everything related to a lang in a single file:
--       the lsp config, treesitter, formatters and extra plugins
--       so in each file you will find props with a 'extra_' prefix
--       this is a custom prop used only on this config, this is not canonical

return {
    bashls = require('langs.bash'),
    emmet_language_server = require('langs.html').emmet,
    html = require('langs.html').html,
    lemminx = require('langs.xml'),
    lua_ls = require('langs.lua'),
    marksman = require('langs.markdown'),
    rust_analyzer = require('langs.rust'),
    vtsls = require('langs.js'),
}
