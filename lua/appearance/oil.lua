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
            show_hidden = true,
        },
    })
end

return M
