local M = {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
}

function M.config()
    local mc = require('multicursor-nvim')
    local keymaps = require('keymaps')
    mc.setup()

    keymaps.multicursor(mc)
end

return M
