local M = {
    'folke/tokyonight.nvim',
    priority = 1000,
}

function M.init()
    vim.cmd.colorscheme('tokyonight-moon')
    vim.cmd.hi('Comment gui=none')
end

return M
