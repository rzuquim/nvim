-- neovide configuration
if not vim.g.neovide then
    return
end

vim.o.guifont = 'Fira Code'
vim.g.neovide_scale_factor = 1.0
vim.g.neovide_cursor_antialiasing = true
vim.g.floaterm_winblend = 15
vim.g.neovide_floating_blur_amount_y = 4.0
vim.g.neovide_remember_window_size = true
vim.g.neovide_padding_top = 15
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
vim.g.neovide_cursor_animation_length = 0.13
vim.g.neovide_transparency = 0.9

local actions = {
    font_incr = function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end,

    font_decr = function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
    end,
    font_reset = function()
        vim.g.neovide_scale_factor = 1.0
    end,
}

require('keymaps').neovide(actions)
