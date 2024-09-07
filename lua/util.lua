local M = {}

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

return M
