local M = {
    'maan2003/lsp_lines.nvim',
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp_lines_setup', { clear = true }),
            callback = function()
                vim.diagnostic.config({
                    virtual_text = false,
                })

                require('lsp_lines').setup()
            end,
        })
    end,
}

return M
