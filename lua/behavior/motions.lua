local M = {
    'aidancz/tT.nvim',
}

function M.config()
    require('tT').setup({
        t = 'f',
        T = 'F',
    })
end

return M
