vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
    desc = "Quitting command and search mode with ESC",
    group = vim.api.nvim_create_augroup("quit-cmd-with-esc", { clear = true }),
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
    end,
})
