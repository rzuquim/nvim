local M = {
    'maan2003/lsp_lines.nvim',
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp_lines_setup', { clear = true }),
            callback = function()
                require('lsp_lines').setup()

                -- NOTE: disabling it by default (see keymaps)
                vim.diagnostic.config({
                    virtual_text = true,
                    virtual_lines = false,
                })

            end,
        })
    end,
}

return M
