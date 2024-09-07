local pwd = vim.fn.getcwd()
local last_dir = ''
if vim.fn.has('win32') == 1 then
    for path in string.gmatch(pwd, '[^\\]+') do -- iterate through dirs
        last_dir = path
    end
else
    for path in string.gmatch(pwd, '[^/]+') do -- iterate through dirs
        last_dir = path
    end
end

local currentProject = function()
    return last_dir
end

-- from: https://www.reddit.com/r/neovim/comments/xy0tu1/cmdheight0_recording_macros_message
-- NOTE: not adding the autocommands to avoid complexity (there is a 1s poll on lua line, so it is not instantaneous)
vim.api.nvim_set_hl(0, 'MacroRec', { fg = '#db4b4b', bold = true })

local function show_macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == '' then
        return ''
    else
        return '%#MacroRec#󰑋 @' .. recording_register .. '%*'
    end
end

local M = {
    'nvim-lualine/lualine.nvim', -- status line
    event = 'VeryLazy',
    opts = {
        options = {
            disabled_filetypes = { 'oil', 'gitsigns-blame' },
        },
        sections = {
            lualine_a = { currentProject },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'macro_recording', fmt = show_macro_recording }, 'mode', 'filename' },
            lualine_x = { 'encoding', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
    },
}

return M
