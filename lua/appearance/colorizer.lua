return {
    -- NOTE: it seems that the previous colorizer is no longer being maintained
    -- 'norcalli/nvim-colorizer.lua',
    -- config = function()
    --     local colorizer = require('colorizer')
    --     colorizer.setup({
    --         'css',
    --         'scss',
    --         'sass',
    --         'javascript',
    --         'javascriptreact',
    --         'javascript.jsx',
    --         'typescript',
    --         'typescriptreact',
    --         'typescript.tsx',
    --         html = {
    --             mode = 'foreground',
    --         },
    --     })
    -- end,
    'catgoose/nvim-colorizer.lua',
    config = function()
        require('colorizer').setup({
            filetypes = {
                'css',
                'scss',
                'sass',
                'javascript',
                'javascriptreact',
                'javascript.jsx',
                'typescript',
                'typescriptreact',
                'typescript.tsx',
            },
        })
    end,
}
