return {
    settings = {
        diagnostics = {
            enable = false,
        },
        ['rust-analyzer'] = {
            checkOnSave = {
                command = 'clippy',
            },
        },
    },
    extra_treesitter = {
        'rust',
    },
    extra_snippets = {
        rust = require('snippets.rust'),
    },
    setup_custom_help = function(custom_help)
        custom_help['rust'] = function(word)
            local cwd = vim.fn.getcwd()
            local url = string.format('file://%s/target/doc/help.html?search=%s', cwd, word)
            vim.fn.system(string.format('$BROWSER %s', vim.fn.shellescape(url)))
        end
    end,
}
