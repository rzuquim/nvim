local M = {
    'aidancz/tT.nvim',
    -- NOTE: .setup() support ended in recent versions and it was not straightforward to make it work again
    commit = '1529316ffa02c4a844c501b5cff49f7b5efda8ae',
}

function M.config()
    require('tT').setup({
        t = 'f',
        T = 'F',
    })
end

return M
