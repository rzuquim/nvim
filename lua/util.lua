local M = {
    system_file_types = { 'oil', 'gitsigns-blame', 'dbui' },
}

function M.close_buffers_by_type(buffer_type)
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')

            if buf_ft == buffer_type then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
end

function M.close_curr_buffer()
    if vim.bo.modified then
        vim.cmd('write!')
    end

    vim.cmd('bdelete!')
end

function M.run_cmd(cmd)
    local handle = io.popen(cmd)
    if handle == nil then
        return nil
    end

    local cmd_stdout = handle:read('*a')
    handle:close()

    return cmd_stdout
end

function M.local_dev_pwd()
    local dev_password = vim.fn.getenv('DEV_PASSWORD')
    if not dev_password then
        vim.notify('Error: DEV_PASSWORD environment variable is not set.', vim.log.levels.ERROR)
        return nil
    end
    return dev_password
end

function M.quit()
    if vim.g.neovide then
        local choice = vim.fn.confirm('Quit?', '&Yes\n&No', 1)
        if choice ~= 1 then
            return
        end
    end
    vim.cmd(':wqa!<CR>')
end

return M
