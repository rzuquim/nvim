local langs = require('langs')
local keymap = require('keymaps')

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
                'latex',
            },
        },
    },
}

local N = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    init = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        vim.g.no_plugin_maps = true
    end,
    opts = {
        select = {
            lookahead = true,
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                -- ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = false,
        },
        move = {
            set_jumps = true,
        },
    },
}

function M.config(_, opts)
    -- NOTE: Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.configs').setup(opts)
end

function N.config(_, opts)
    require('nvim-treesitter-textobjects').setup(opts)

    local ts_select = require('nvim-treesitter-textobjects.select')
    local ts_swap = require('nvim-treesitter-textobjects.swap')
    local ts_move = require('nvim-treesitter-textobjects.move')
    keymap.treesitter(ts_select, ts_swap, ts_move)
end

return { M, N }
