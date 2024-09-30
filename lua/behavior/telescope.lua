local keymaps = require('keymaps')
local icons = require('appearance.icons')

local M = {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        {
            -- NOTE: see telescope-fzf-native on
            --       https://github.com/nvim-lua/kickstart.nvim/?tab=readme-ov-file#windows-installation
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
    },
}

-- NOTE: this is basically the same as running the default action 'gitstatus'
--       but i am keeping for future reference
local function git_changed_files(pickers, finders, previewers, conf)
    local handle = io.popen('git status --porcelain')
    if handle == nil then
        return
    end
    local result = handle:read('*a')
    handle:close()

    local entries = {}

    for line in result:gmatch('[^\r\n]+') do
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

        table.insert(entries, entry)
    end

    pickers
        .new({}, {
            prompt_title = 'changed files',
            finder = finders.new_table({
                results = entries,
                entry_maker = function(entry)
                    return {
                        value = entry.filename,
                        display = function(display_entry)
                            return string.format('%s %s', entry.icon, display_entry.value)
                        end,
                        ordinal = entry.filename,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            previewer = previewers.git_file_diff.new({}),
        })
        :find()
end

function M.config()
    local telescope = require('telescope')
    local telescope_builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    local actions = require('telescope.actions')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local previewers = require('telescope.previewers')
    local conf = require('telescope.config').values
    local custom_actions = {
        git_changed_files = function()
            git_changed_files(pickers, finders, previewers, conf)
        end,
    }

    local mappings = keymaps.telescope(telescope_builtin, actions, custom_actions)

    telescope.setup({
        defaults = {
            mappings = mappings,
        },
        extensions = {
            ['ui-select'] = { themes.get_dropdown() },
        },
    })

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
end

return M
