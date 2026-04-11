local langs = require('langs')
local keymap = require('keymaps')
local util = require('util')

local TS = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
}

local TSTO = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    init = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        vim.g.no_plugin_maps = true
    end,
}

function TS.config()
    -- NOTE: Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter').setup({
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
    })
end

function TSTO.config()
    require('nvim-treesitter-textobjects').setup({
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
    })

    local ts_select = require('nvim-treesitter-textobjects.select')
    local ts_swap = require('nvim-treesitter-textobjects.swap')
    local ts_move = require('nvim-treesitter-textobjects.move')
    keymap.treesitter(ts_select, ts_swap, ts_move)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = util.system_file_types,
    callback = function(args)
        vim.treesitter.stop(args.buf)
    end,
})

return { TS, TSTO }
