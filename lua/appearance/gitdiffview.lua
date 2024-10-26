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

local function git_repo_root()
    local handle = io.popen('git rev-parse --show-toplevel 2> /dev/null')
    if not handle then
        return ''
    end
    local git_root = handle:read('*a')
    handle:close()
    return git_root:match('^%s*(.-)%s*$') -- Trim whitespace
end

local custom_git_changed_files = function()
    local git_root = git_repo_root()
    local telescope_cfg = require('behavior.telescope')
    local previewers = require('telescope.previewers')
    local cwd = vim.fn.getcwd()

    telescope_cfg.cmd_picker('git status --porcelain', {
        prompt_title = 'changed files',
        parse_line = function(line)
            local status = line:sub(1, 2) -- Get the first two characters for status
            local absolute_path = git_root .. '/' .. line:sub(4) -- Filename starts at the 4th character

            -- excluding files that are not on the cwd
            if not absolute_path:find(cwd, 1, true) then
                return nil
            end

            local relative_path = absolute_path:sub(#cwd + 2)

            local entry = {
                file_path = absolute_path,
                relative_path = relative_path,
            }
            if status:match('D') then
                entry.icon = icons.git.FileDelete
            elseif status:match('A') then
                entry.icon = icons.git.LineAdded
            elseif status:match('%?') then
                entry.icon = icons.git.FileUnstaged
            else
                entry.icon = icons.git.LineModified
            end

            return entry
        end,
        entry_maker = function(entry)
            return {
                value = entry.file_path,
                display = function()
                    return string.format('%s %s', entry.icon, entry.relative_path)
                end,
                ordinal = entry.file_path,
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
