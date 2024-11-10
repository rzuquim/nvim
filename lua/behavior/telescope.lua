local keymaps = require('keymaps')
local icons = require('appearance.icons')
local util = require('util')

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

M.cmd_picker = function(cmd, opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions_state = require('telescope.actions.state')
    local actions = require('telescope.actions')
    local conf = require('telescope.config').values

    local cmd_stdout = util.run_cmd(cmd)
    if not cmd_stdout then
        vim.notify('Err: could not run cmd: ' .. cmd)
        return nil
    end

    local entries = {}
    for line in cmd_stdout:gmatch('[^\r\n]+') do
        if opts.parse_line then
            table.insert(entries, opts.parse_line(line))
        else
            table.insert(entries, line)
        end
    end

    local co = nil
    local custom_mappings = nil
    if opts.custom_select then
        co = coroutine.running()
        local custom_select = function(prompt_bufnr)
            local selected_entry = actions_state.get_selected_entry()
            opts.custom_select(selected_entry)
            actions.close(prompt_bufnr)
            coroutine.resume(co, selected_entry)
        end

        custom_mappings = function(_, map)
            map('n', '<CR>', custom_select)
            map('i', '<CR>', custom_select)
            return true
        end
    end

    local picker_opts = {
        prompt_title = opts.prompt_title,
        finder = finders.new_table({
            results = entries,
            entry_maker = opts.entry_maker,
        }),
        sorter = opts.sorter or conf.generic_sorter({}),
        previewer = opts.previewer,
        attach_mappings = custom_mappings,
    }

    pickers.new({}, picker_opts):find()

    return co
end

function M.config()
    local telescope = require('telescope')
    local telescope_builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    local actions = require('telescope.actions')

    local mappings = keymaps.telescope(telescope_builtin, actions)

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
