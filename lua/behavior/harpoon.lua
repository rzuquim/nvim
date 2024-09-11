local util = require('util')
local keymaps = require('keymaps')

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
