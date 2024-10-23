local icons = require('appearance.icons')
local keymaps = require('keymaps')

local M = {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
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

-- NOTE: this is basically the same as running the default action 'gitstatus'
--       but i am keeping for future reference
local custom_git_changed_files = function()
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

function M.config()
    require('diffview').setup({
        enhanced_diff_hl = true,
    })

    keymaps.git_diff_view({
        toggle_git_diff_view = toggle_git_diff_view,
        custom_git_changed_files = custom_git_changed_files,
    })
end

return M
