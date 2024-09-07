return {
    'norcalli/nvim-colorizer.lua',
    config = function()
        local colorizer = require('colorizer')
        colorizer.setup({
            'css',
            'scss',
            'sass',
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
            html = {
                mode = 'foreground',
            },
        })
    end,
}
