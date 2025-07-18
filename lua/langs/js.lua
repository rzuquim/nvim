local function eslint_extra_condition()
    local cwd = vim.fn.getcwd()

    local config_files = {
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
        'eslint.config.ts',
    }

    for _, filename in ipairs(config_files) do
        local path = cwd .. '/' .. filename
        if vim.loop.fs_stat(path) then
            return true
        end
    end

    return false
end

return {
    -- disable_lsp = true,
    on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    extra_formatters = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
    },
    extra_linters = {
        javascript = { 'eslint_d', eslint_extra_condition },
        javascriptreact = { 'eslint_d', eslint_extra_condition },
        typescript = { 'eslint_d', eslint_extra_condition },
        typescriptreact = { 'eslint_d', eslint_extra_condition },
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
    -- extra_plugins = {
    --     {
    --         'pmizio/typescript-tools.nvim',
    --         dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    --         config = function()
    --             require('typescript-tools').setup({
    --                 on_attach = function(client, _)
    --                     -- NOTE: using prettier
    --                     client.server_capabilities.documentFormattingProvider = false
    --                     client.server_capabilities.documentRangeFormattingProvider = false
    --                 end,
    --             })
    --         end,
    --     },
    -- },
    -- TODO: figure out workspace diagnostics
    extensions = { 'js', 'jsx', 'ts', 'tsx' },
    -- diagnostics = function() end,
}
