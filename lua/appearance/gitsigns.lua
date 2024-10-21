local keymaps = require('keymaps')
local icons = require('appearance.icons')

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

-- NOTE: this is basically the same as running the default action 'gitstatus'
--       but i am keeping for future reference
local custom_changed_files = function()
    local telescope_cfg = require('behavior.telescope')
    local previewers = require('telescope.previewers')
    telescope_cfg.cmd_picker('git status --porcelain', {
        prompt_title = 'changed files',
        parse_line = function(line)
            local status = line:sub(1, 2) -- Get the first two characters for status
            local filename = line:sub(4) -- Filename starts at the 4th character

            local entry = {}
            if status:match('D') then
                entry = { icon = icons.git.FileDeleted, filename = filename }
            elseif status:match('A') then
                entry = { icon = icons.git.LineAdded, filename = filename }
            elseif status:match('%?') then
                entry = { icon = icons.git.FileUnstaged, filename = filename }
            else
                entry = { icon = icons.git.LineModified, filename = filename }
            end

            return entry
        end,
        entry_maker = function(entry)
            return {
                value = entry.filename,
                display = function(display_entry)
                    return string.format('%s %s', entry.icon, display_entry.value)
                end,
                ordinal = entry.filename,
            }
        end,
        previewer = previewers.git_file_diff.new({}),
    })
end

M.opts.on_attach = function(buf)
    keymaps.git(buf, toggle_blame, custom_changed_files)
end

return M
