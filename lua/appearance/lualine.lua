local util = require('util')
local theme = require('appearance.theme')

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

-- NOTE: we set a unique color based on the cwd
local hash = 0
for i = 1, #pwd do
    hash = (hash * 31 + string.byte(i)) % 0xFFFFFF
end

local r = bit.rshift(bit.band(hash, 0xFF0000), 16)
local g = bit.rshift(bit.band(hash, 0x00FF00), 8)
local b = bit.band(hash, 0x0000FF)

-- NOTE: making sure in light theme the bg color is dark
if theme.theme == 'dark' then
    local brightness_threshold = 128 -- 0x80
    if r < brightness_threshold then
        r = r + brightness_threshold
    end

    if g < brightness_threshold then
        g = g + brightness_threshold
    end

    if b < brightness_threshold then
        b = b + brightness_threshold
    end
else
    local brightness_threshold = 64 -- 0x40
    if r > brightness_threshold then
        r = r - brightness_threshold
    end

    if g > brightness_threshold then
        g = g - brightness_threshold
    end

    if b > brightness_threshold then
        b = b - brightness_threshold
    end
end

local bg_color = string.format('#%02x%02x%02x', r, g, b)

local currentProject = {
    function()
        return last_dir
    end,
    color = { bg = bg_color },
    separator = { right = '' },
}

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
            disabled_filetypes = util.system_file_types,
        },
        sections = {
            lualine_a = {
                currentProject,
            },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'macro_recording', fmt = show_macro_recording }, 'mode', 'filename' },
            lualine_x = { 'encoding', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = {
                { 'location', color = { bg = bg_color }, separator = { left = '' } },
            },
        },
    },
}

return M
