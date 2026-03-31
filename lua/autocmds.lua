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
        local filename = vim.fn.expand('%:p')
        if filename == '' then
            return
        end
        vim.cmd('silent !zathura ' .. filename .. ' &')
        vim.cmd('let tobedeleted = bufnr(\'%\') | b# | exe "bd! " . tobedeleted')
    end,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
    pattern = { '*.mp4', '*.mkv', '*.webm', '*.avi', '*.m4a', '*.mp3', '*.ogg' },
    callback = function()
        local filename = vim.fn.expand('%:p')

        vim.fn.jobstart({ 'setsid', 'mpv', filename }, { detach = true })

        vim.cmd('setlocal buftype=nofile')
        vim.cmd('setlocal bufhidden=wipe')

        vim.schedule(function()
            vim.cmd('bd!')
        end)
    end,
})
