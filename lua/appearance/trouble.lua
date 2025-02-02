local M = {
    'folke/trouble.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'folke/todo-comments.nvim',
    },
    event = 'VeryLazy',
    cmd = 'Trouble',
}

-- local function run_workspace_diagnostics()
--     print('run')
--     local files = vim.fn.systemlist('git ls-files')
--
--     local function has_pertinent_cmd(file)
--         local ext = file:match('%.([^%.]+)$')
--         for _, invalid in ipairs(invalid_extensions) do
--             if invalid == ext then
--                 return false
--             end
--         end
--
--         return true
--     end
--
--     local co = coroutine.create(function()
--         local total_files = #files
--         for i, file in ipairs(files) do
--             if has_pertinent_cmd(file) then
--                 vim.cmd('edit ' .. file)
--                 vim.lsp.buf_request(
--                     0,
--                     'textDocument/diagnostic',
--                     { textDocument = vim.lsp.util.make_text_document_params() },
--                     function(err, result, _)
--                         if err then
--                             vim.notify('Error running diagnostics: ' .. err.message, vim.log.levels.ERROR)
--                         else
--                             print('Diagnostics for ' .. file .. ':')
--                             vim.print(result)
--                         end
--                     end
--                 )
--
--                 -- Update progress indicator
--                 vim.notify(string.format('Processing file %d/%d: %s', i, total_files, file), vim.log.levels.INFO)
--
--                 -- Yield to allow other operations to continue
--                 coroutine.yield()
--             end
--         end
--
--         vim.notify('Workspace diagnostics completed!', vim.log.levels.INFO)
--     end)
--
--     local function resume_co()
--         if coroutine.status(co) == 'dead' then
--             return
--         end
--
--         coroutine.resume(co)
--         vim.defer_fn(resume_co, 100)
--     end
--
--     resume_co()
-- end

function M.config()
    local trouble = require('trouble')
    local keymaps = require('keymaps')

    trouble.setup({
        focus = true,

        win = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.4,
        },
    })

    local is_open = false

    keymaps.diagnostics({
        workspace_diagnostics = function()
            if is_open then
                vim.cmd('Trouble diagnostics close')
                is_open = false
                return
            end

            -- run_workspace_diagnostics()

            is_open = true
            vim.cmd('Trouble diagnostics open')
        end,
    })
end

return M
