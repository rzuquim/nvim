local pwd = vim.fn.getcwd()
local last_dir = ''
for path in string.gmatch(pwd, '[^/]+') do -- iterate through dirs
    last_dir = path
end

local currentProject = function()
    return last_dir
end

local M = {
    'nvim-lualine/lualine.nvim', -- status line
    event = 'VeryLazy',
    opts = {
        options = {
            disabled_filetypes = { 'oil' },
        },
        sections = {
            lualine_a = { currentProject },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'mode', 'filename' },
            lualine_x = { 'encoding', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
    },
}

return M
