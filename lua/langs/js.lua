local function extra_condition()
    local cwd = vim.fn.getcwd()
    local eslint_config = cwd .. '/eslint.config.js'

    local stat = vim.loop.fs_stat(eslint_config)
    return stat ~= nil
end

return {
    extra_formatters = {
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
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
}
