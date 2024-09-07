local keymaps = require('keymaps')

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
    local telescope_themes = require('telescope.themes')

    telescope.setup({
        extensions = {
            ['ui-select'] = { telescope_themes.get_dropdown() },
        },
    })

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    keymaps.telescope(telescope_builtin)
end

return M
