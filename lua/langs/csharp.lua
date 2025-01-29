local M = {
    extra_treesitter = {
        'c_sharp',
    },
    extra_snippets = {
        cs = require('snippets.charp'),
    },
    extra_dap = {},
}

local selected_csproj_dir = nil
local function debug_launch()
    local util = require('util')
    local telescope_helpers = require('behavior.telescope_helpers')

    local selected_csproj = nil
    local co = telescope_helpers.cmd_picker('rg --files --iglob *.csproj', {
        prompt_title = 'dotnet projects',
        custom_select = function(selected_item)
            selected_csproj = selected_item[1]
        end,
    })

    if co then
        coroutine.yield()
    end

    if not selected_csproj then
        vim.notify('Err: No .csproj selected.')
        return nil
    end

    local csproj = vim.fn.getcwd() .. '/' .. selected_csproj
    local output = util.run_cmd('dotnet build ' .. csproj)
    if not output then
        vim.notify('Err: could not run `dotnet build ' .. csproj .. '`')
        return ''
    end

    local dll_paths = {}
    for path in output:gmatch('/[^\n]+%.dll') do
        table.insert(dll_paths, path)
    end

    if #dll_paths == 0 then
        vim.notify('Err: could not find dll: ' .. output)
        return ''
    end

    if #dll_paths == 1 then
        selected_csproj_dir = vim.fn.fnamemodify(csproj, ':h')
        return dll_paths[1]
    end

    vim.inspect('TODO: multiple dlls')
end

M.extra_dap.netcoredbg = function(dap)
    dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
        {
            type = 'coreclr',
            name = function()
                print('name')
                return 'launch - netcoredbg'
            end,
            request = function()
                print('request')
                return 'launch'
            end,
            program = function()
                print('program')
                return debug_launch()
            end,
            cwd = function()
                return selected_csproj_dir
            end,
        },
        -- TODO: attach using functions
        -- xargs -I {} sh -c 'echo "PID: {}, CWD: $(readlink /proc/{}/cwd)"'
        -- {
        --     type = 'coreclr',
        --     name = 'attach',
        --     request = 'attach',
        --     program = attach,
        --     cwd = function()
        --         return selected_csproj_dir
        --     end,
        -- },
    }
end

return M
