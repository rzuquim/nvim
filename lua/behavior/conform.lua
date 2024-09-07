local langs = require('langs')
local keymaps = require('keymaps')

local formatters_by_ft = {}
for _, settings in pairs(langs) do
    if settings.extra_formatters then
        for ft, formatter in pairs(settings.extra_formatters) do
            formatters_by_ft[ft] = formatter
        end
    end
end

local M = {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {},
}

function M.config()
    local conform = require('conform')
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
    })
    keymaps.format(conform)
end

return M
