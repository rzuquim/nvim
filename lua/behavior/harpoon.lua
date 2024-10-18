-- NOTE: I am not using this one so I removed it from init but i am keeping the config in the case I change my mind

local util = require('util')
local keymaps = require('keymaps')

-- function M.harpoon()
--     local mark = require('harpoon.mark')
--     local ui = require('harpoon.ui')
--
--     keymap('n', ',', ui.toggle_quick_menu)
--     keymap('n', ',,', mark.add_file)
--
--     keymap('n', ',f', function()
--         ui.nav_file(1)
--     end)
--     keymap('n', ',d', function()
--         ui.nav_file(2)
--     end)
--     keymap('n', ',s', function()
--         ui.nav_file(3)
--     end)
--     keymap('n', ',a', function()
--         ui.nav_file(4)
--     end)
-- end

return {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    config = function()
        require('harpoon').setup({
            global_settings = {
                save_on_toggle = false,
                save_on_change = true,
                enter_on_sendcmd = false,
                tmux_autoclose_windows = false,

                excluded_filetypes = util.system_file_types,
                mark_branch = false,

                tabline = false,
                tabline_prefix = '   ',
                tabline_suffix = '   ',
            },
        })

        keymaps.harpoon()
    end,
}
