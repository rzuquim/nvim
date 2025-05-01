local M = {
    'folke/tokyonight.nvim',
    priority = 1000,
    theme = '',
    dependencies = { 'yorik1984/newpaper.nvim' },
}

local current_hour = os.date('%H')
if tonumber(current_hour) > 11 or tonumber(current_hour) < 8 then
    M.theme = 'dark'
else
    M.theme = 'light'
end

function M.init()
    local colorscheme

    if M.theme == 'dark' then
        colorscheme = 'tokyonight' -- night time
    else
        colorscheme = 'newpaper' -- day time
    end

    vim.cmd.colorscheme(colorscheme)
    vim.cmd.hi('Comment gui=none')
end

function M.config()
    if M.theme == 'dark' then
        require('tokyonight').setup({
            transparent = true,
            styles = {
                sidebars = 'transparent',
                floats = 'transparent',
            },
        })
    else
        require('newpaper').setup({
            style = 'light',
        })
    end
end

return M
