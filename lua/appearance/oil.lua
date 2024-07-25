local M = {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
    require('oil').setup({
        keymaps = KEYMAPS.oil(),
        use_default_keymaps = false,
    })
end

return M
