return {
    'echasnovski/mini.nvim',
    config = function()
        -- Better Around/Inside textobjects
        -- Examples:
        --  - vib  - [V]isually select [I]nside brackets
        --  - ciq  - [C]hange [I]nside quotes
        require('mini.ai').setup({ n_lines = 500 })

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        -- - siW) -  [S]urround [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup({
            mappings = {
                add = 's',
                delete = 'sd',
                replace = 'sr',

                -- NOTE: disabled
                find = '',
                find_left = '',
                highlight = '',
                update_n_lines = '',
                suffix_last = '',
                suffix_next = '',
            },
        })
    end,
}
