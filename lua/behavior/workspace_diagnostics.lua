local M = {
    'artemave/workspace-diagnostics.nvim',
}

function M.config()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('workspace-diagnostics-lsp-attach', { clear = true }),
        callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if not client then
                print('Could not find lsp client with id: ' .. event.data.client_id)
                return
            end
            require('workspace-diagnostics').populate_workspace_diagnostics(client, event.buf)
        end,
    })
end

return M
