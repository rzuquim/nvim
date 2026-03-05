vim.api.nvim_create_autocmd('CmdwinEnter', {
    desc = 'Quitting command and search mode with ESC',
    group = vim.api.nvim_create_augroup('quit-cmd-with-esc', { clear = true }),
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
    end,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
    pattern = '*.pdf',
    callback = function()
        local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
        vim.cmd('silent !zathura ' .. filename .. ' &')
        vim.cmd('let tobedeleted = bufnr(\'%\') | b# | exe "bd! " . tobedeleted')
    end,
})
