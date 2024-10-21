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

M.cmd_picker = function(cmd, opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    local handle = io.popen(cmd)
    if handle == nil then
        return
    end
    local cmd_stdout = handle:read('*a')
    handle:close()

    local entries = {}
    for line in cmd_stdout:gmatch('[^\r\n]+') do
        if opts.parse_line then
            table.insert(entries, opts.parse_line(line))
        else
            table.insert(entries, line)
        end
    end

    local finder_opts = { results = entries }

    if opts.entry_maker then
        finder_opts.entry_maker = opts.entry_maker
    end

    if opts.find_command then
        finder_opts.find_command = opts.find_command
    end

    local picker_opts = {
        prompt_title = opts.prompt_title,
        finder = finders.new_table(finder_opts),
    }

    if opts.sorter then
        picker_opts.sorter = opts.sorter
    else
        picker_opts.sorter = conf.generic_sorter({})
    end

    if opts.previewer then
        picker_opts.previewer = opts.previewer
    end

    pickers.new({}, picker_opts):find()
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
