local keymaps = require('keymaps')

local M = {
    'maan2003/lsp_lines.nvim',
}

function M.config()
    keymaps.lsp_lines(M)

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_lines_setup', { clear = true }),
        callback = function()
            require('lsp_lines').setup()
            M.disable_lsp_lines()
        end,
    })

    vim.api.nvim_create_autocmd('InsertEnter', {
        group = vim.api.nvim_create_augroup('lsp_lines_disable_on_insert_mode', { clear = true }),
        callback = M.disable_lsp_lines,
    })
end

local lsp_lines_enabled = false
function M.toggle_lsp_lines()
    lsp_lines_enabled = not lsp_lines_enabled
    vim.diagnostic.config({ virtual_lines = lsp_lines_enabled, virtual_text = not lsp_lines_enabled })
end

function M.disable_lsp_lines()
    lsp_lines_enabled = false
    vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
end

return M
