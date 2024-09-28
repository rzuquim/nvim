local M = {
    'folke/tokyonight.nvim',
    priority = 1000,
}

function M.init()
    vim.cmd.colorscheme('tokyonight-moon')
    vim.cmd.hi('Comment gui=none')
end

function M.config()
    require('tokyonight').setup({
        transparent = true,
        styles = {
            sidebars = 'transparent',
            floats = 'transparent',
        },
    })
end

return M
