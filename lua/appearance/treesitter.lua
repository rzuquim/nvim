local langs = require('langs')

local M = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        -- TODO: "c", "diff", "html", "markdown", "vim", "vimdoc"
        ensure_installed = langs.treesitter(),
        auto_install = true,
        highlight = {
            enable = true,
            -- NOTE: Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            -- additional_vim_regex_highlighting = { "ruby" },
        },
        indent = {
            enable = true,
            disable = {
                'liquid', -- FIX: use ident on liquid files
                'latex'
            },
        },
    },
}

function M.config(_, opts)
    -- NOTE: Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.configs').setup(opts)

    -- TODO: Check additional nvim-treesitter modules that you can use to interact
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
end

return M
