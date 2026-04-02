local opts = {
    lsp = {
        enabled = true, -- Enable builtin roslyn lsp
        roslynator_enabled = true, -- Automatically enable roslynator analyzer
        easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
        analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
        auto_refresh_codelens = false,
    },
    csproj_mappings = true,
    fsproj_mappings = true,
    auto_bootstrap_namespace = {
        --block_scoped, file_scoped
        type = 'file_scoped',
        enabled = true,
    },
    server = {
        ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
        log_level = 'All',
    },
    picker = 'telescope',
    background_scanning = true,
    notifications = {
        handler = false,
    },
    diagnostics = {
        default_severity = 'error',
        setqflist = false,
    },
    terminal = {},
    new = {},
    debugger = {},
    test_runner = {
        auto_start_testrunner = false,
    },
}

local M = {
    -- NOTE: disabling cs_ls
    disable_lsp = true,
    extra_formatters = {
        cs = {
            {
                'csharpier',
                config = function()
                    return {
                        command = vim.fn.stdpath('data') .. '/mason/bin/csharpier',
                        args = { 'format' },
                        stdin = true,
                    }
                end,
            },
        },
    },
    extra_treesitter = {
        'c_sharp',
    },
    extra_snippets = {
        cs = require('snippets.csharp'),
    },
    extra_dap = {},
    extra_plugins = {
        {
            'GustavEikaas/easy-dotnet.nvim',
            config = function()
                local dotnet = require('easy-dotnet')
                local lsp_client_name = require('easy-dotnet.constants').lsp_client_name

                vim.api.nvim_create_autocmd('LspAttach', {
                    group = vim.api.nvim_create_augroup('easy-dotnet-lsp-attach', { clear = true }),
                    callback = function(evt)
                        local client = vim.lsp.get_client_by_id(evt.data.client_id)
                        if client == nil then
                            return
                        end

                        if client.name == lsp_client_name then
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                            client.server_capabilities.codeLensProvider = nil
                        end
                    end,
                })

                dotnet.setup(opts)
            end,
        },
    },
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
