local function extra_condition()
    local cwd = vim.fn.getcwd() -- Get the current working directory
    local eslint_config = cwd .. '/eslint.config.js'

    local stat = vim.loop.fs_stat(eslint_config)
    return stat ~= nil
end

return {
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
}
