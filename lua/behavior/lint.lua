local M = {
    'mfussenegger/nvim-lint',
    lazy = false,
    keys = {},
}

function M.config()
    local langs = require('langs')
    local lint = require('lint')

    lint.linters_by_ft = langs.linters_by_ft()
    local lint_conditions_by_ft = langs.lint_conditions()

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function(ev)
            local ft = vim.bo.filetype
            if lint_conditions_by_ft[ft] then
                if lint.linters_by_ft[ft].extra_condition then
                    if not lint.linters_by_ft[ft].extra_condition(ev) then
                        return
                    end
                end
            end

            -- NOTE: example in https://github.com/Integralist/nvim/blob/main/lua%2Fplugins%2Flint-and-format.lua
            lint.try_lint()
        end,
    })
end

return M
