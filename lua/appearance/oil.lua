local keymaps = require('keymaps')

local M = {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
}

function M.config()
    require('oil').setup({
        keymaps = keymaps.oil(),
        use_default_keymaps = false,
        view_options = {
            show_hidden = false,
            is_hidden_file = function(name)
                return name:match('%.cs.meta$')
            end,
        },
    })
end

return M
