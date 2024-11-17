local keymaps = require('keymaps')
local helpers = require('behavior.telescope_helpers')

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

function M.config()
    local telescope = require('telescope')
    local telescope_builtin = require('telescope.builtin')
    local themes = require('telescope.themes')
    local actions = require('telescope.actions')
    local previewers = require('telescope.previewers')

    local mappings = keymaps.telescope(telescope_builtin, actions)

    telescope.setup({
        defaults = {
            mappings = mappings,
            buffer_previewer_maker = helpers.max_size_previewer(previewers),
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
