local keymap = require('keymaps')

local M = {
    'gruvw/strudel.nvim',
    build = 'npm ci',
    ft = { 'strudel' },
    config = function()
        require('strudel').setup()
        -- $: s("[bd <hh oh>]*2").bank("tr909").dec(.4)
    end,
}

vim.filetype.add({
    extension = {
        str = 'strudel',
    },
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'strudel',
    callback = function()
        -- vim.lsp.start({
        --     name = 'strudel-lsp',
        --     cmd = { 'node', '/path/to/strudel-lsp-server/server/out/server.js', '--stdio' },
        --     root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
        -- })
        --

        -- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
        -- parser_config.strudel = {
        --     install_info = {
        --         url = 'https://github.com/ntsk/tree-sitter-strudel',
        --         files = { 'src/parser.c' },
        --         branch = 'main',
        --     },
        --     filetype = 'strudel',
        -- }
    end,
})

return M
