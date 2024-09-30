local keymaps = require('keymaps')
local icons = require('appearance.icons')

local blame_active = false
local toggle_blame = function()
    local gitsigns = require('gitsigns')
    local utils = require('util')

    if blame_active then
        utils.close_buffers_by_type('gitsigns-blame')
    else
        -- NOTE: not loosing editor window
        local curr_win = vim.api.nvim_get_current_win()
        gitsigns.blame(function()
            vim.api.nvim_set_current_win(curr_win)
        end)
    end
    -- Toggle the state
    blame_active = not blame_active
end

local M = {
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
    cmd = 'Gitsigns',
    opts = {
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 1000,
            ignore_whitespace = true,
        },

        on_attach = function(buf)
            keymaps.git(buf, toggle_blame)
        end,
        signs = {
            add = { text = '┃' },
            change = { text = '┃' },
            delete = { text = icons.git.LineRemoved },
            topdelete = { text = icons.git.LineRemoved },
            changedelete = { text = icons.git.LineModified },
            untracked = { text = '┆' },
        },
        signs_staged = {
            add = { text = '┃' },
            change = { text = '┃' },
            delete = { text = icons.git.LineRemoved },
            topdelete = { text = icons.git.LineRemoved },
            changedelete = { text = icons.git.LineModified },
            untracked = { text = '┆' },
        },
    },
}

return M
