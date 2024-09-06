local M = {
    'numToStr/Comment.nvim',
    lazy = false,
    dependencies = {
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            event = 'VeryLazy',
        },
    },
}

function M.config()
    local prehook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    require('Comment').setup(vim.tbl_deep_extend('force', KEYMAPS.comments(), {
        pre_hook = prehook,
    }))
end

return M
