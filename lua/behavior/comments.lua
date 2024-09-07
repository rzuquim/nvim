local keymaps = require('keymaps')

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
    local comment = require('Comment')
    local ts_comment = require('ts_context_commentstring.integrations.comment_nvim')

    comment.setup(vim.tbl_deep_extend('force', keymaps.comments(), {
        pre_hook = ts_comment.create_pre_hook(),
    }))
end

return M
