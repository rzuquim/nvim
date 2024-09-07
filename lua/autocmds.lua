vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- NOTE: enabling text wrap and spell check when it matters
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'gitcommit', 'markdown', 'text' },
    group = vim.api.nvim_create_augroup('text-editing-settings', { clear = true }),
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
    desc = 'Quitting command and search mode with ESC',
    group = vim.api.nvim_create_augroup('quit-cmd-with-esc', { clear = true }),
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
    end,
})
