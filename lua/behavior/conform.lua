local langs = require('langs')
local keymaps = require('keymaps')

local M = {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {},
}

function M.config()
    local conform = require('conform')
    local formatters_by_ft = langs.formatters_by_ft()
    local config_by_formatter = langs.formatters_config()

    local formatters = {}
    for formatter, config in pairs(config_by_formatter) do
        formatters[formatter] = config()
    end

    conform.setup({
        notify_on_error = false,

        -- NOTE: disabling format on save
        --[[ format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            local disable_filetypes = { c = true, cpp = true }
            return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
        end, ]]

        formatters_by_ft = formatters_by_ft,
        formatters = formatters,
    })
    keymaps.format(conform)
end

return M
