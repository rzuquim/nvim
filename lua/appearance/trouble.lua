return {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
    opts = {
        focus = true,

        win = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.4,
        },
    },
    cmd = 'Trouble',
}
