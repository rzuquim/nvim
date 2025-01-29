local function extra_condition()
    local cwd = vim.fn.getcwd()
    local eslint_config = cwd .. '/eslint.config.js'

    local stat = vim.loop.fs_stat(eslint_config)
    return stat ~= nil
end

return {
    disable_lsp = true,
    extra_formatters = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
    },
    extra_linters = {
        javascript = { 'eslint_d', extra_condition },
        javascriptreact = { 'eslint_d', extra_condition },
        typescript = { 'eslint_d', extra_condition },
        typescriptreact = { 'eslint_d', extra_condition },
    },
    extra_treesitter = {
        'javascript',
        'tsx',
        'typescript',
    },
    extra_snippets = {
        javascript = require('snippets.js'),
        javascriptreact = require('snippets.js'),
        typescript = require('snippets.ts'),
        typescriptreact = require('snippets.ts'),
    },
    extra_plugins = {
        {
            'pmizio/typescript-tools.nvim',
            dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
            config = function()
                require('typescript-tools').setup({
                    on_attach = function(client, _)
                        -- NOTE: using prettier
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                })
            end,
        },
    },
}
