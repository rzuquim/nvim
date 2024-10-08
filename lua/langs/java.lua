local M = {
    extra_treesitter = {
        'java',
    },
    extra_plugins = {
        {
            'mfussenegger/nvim-jdtls',
            ft = { 'java' },
            config = function()
                local jdtls = require('jdtls')
                local config = {
                    -- TODO: windows support
                    -- TODO: configure lombok (https://www.youtube.com/watch?v=C7juSZsM2Fg) or the jdtls docs
                    cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls') },
                    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
                }
                jdtls.start_or_attach(config)
            end,
        },
    },
}

return M
