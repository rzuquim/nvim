local M = {
    'sindrets/diffview.nvim',
}

local diff_view_open = false
local function toggle_git_diff_view()
    if diff_view_open then
        vim.cmd('DiffviewOpen')
    else
        vim.cmd('DiffviewClose')
    end
    diff_view_open = not diff_view_open
end

function M.config()
    local keymaps = require('keymaps')
    require('diffview').setup({
        enhanced_diff_hl = true,
    })
    keymaps.git_diff_view({ toggle_git_diff_view = toggle_git_diff_view })
end

return M
