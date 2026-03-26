local keymaps = require('keymaps')
local hidden_files = require('hidden_files')

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
                for _, hidden in ipairs(hidden_files) do
                    if name:match(hidden) then
                        return true
                    end
                end
                return false
            end,
        },
    })
end

return M
