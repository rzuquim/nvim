vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- NOTE: storing a copy of the last value so we don't mess with the registers unless necessary
local last_yanked = {}

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Not copying empty lines',
    group = vim.api.nvim_create_augroup('not-copy-empty', { clear = true }),
    callback = function()
        local yanked_text = vim.v.event.regcontents[1]

        -- NOTE: empty text should not be yanked
        if not yanked_text:match('^%s*$') then
            last_yanked.regcontents = yanked_text
            last_yanked.regtype = vim.v.event.regtype

            return
        end

        vim.fn.setreg('+', last_yanked.regcontents, last_yanked.regtype)
    end,
})
