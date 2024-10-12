local keymaps = require('keymaps')

local markdown_preview = {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}

local M = {
    extra_formatters = {
        markdown = { 'prettierd' },
    },
    extra_plugins = {
        markdown_preview,
        -- TODO: add image support: [@linkarzu](https://github.com/linkarzu/dotfiles-latest)
    },
}

function markdown_preview.config()
    local telescope_builtin = require('telescope.builtin')
    require('render-markdown').setup({
        heading = {
            width = 'block',
            icons = { '' },
            left_margin = 2,
            min_width = 116,
            border = true,
            border_virtual = true,
        },
        bullet = {
            enabled = true,
            icons = { '●', '○', '◆', '◇' },
            left_pad = 1,
            right_pad = 1,
        },
        pipe_table = {
            preset = 'round',
            min_width = 20,
        },
        checkbox = {
            checked = { scope_highlight = '@markup.strikethrough' },
            custom = {
                todo = { raw = '[-]', rendered = '󱋭 ', highlight = 'RenderMarkdownTodo' },
            },
        },
    })

    -- NOTE: enabling text wrap and spell check when it matters
    local orinal_columns = vim.o.columns
    vim.api.nvim_create_autocmd('BufWinEnter', {
        group = vim.api.nvim_create_augroup('markdown-setup', { clear = true }),
        callback = function()
            if vim.bo.filetype ~= 'markdown' then
                vim.opt_local.columns = orinal_columns
                return
            end

            vim.opt_local.spell = true

            -- NOTE: the render-markdown plugin works better with 2 sized tabs
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2

            -- NOTE: this is not what I want yet, but is good enough
            --       since settings the columns will crop the vim canvas (vertical splits loose precious screen space)
            vim.opt_local.wrap = true
            vim.opt_local.textwidth = 0
            vim.opt_local.wrapmargin = 0
            vim.opt_local.linebreak = true
            vim.opt_local.columns = 125 -- NOTE: dont known why but we need 5 extra chars (enabling markdown_preview)
            vim.opt_local.spelllang = 'en,es,br,names'
        end,
    })

    vim.api.nvim_create_autocmd('VimResized', {
        group = vim.api.nvim_create_augroup('markdown-resize-capture', { clear = true }),
        callback = function()
            orinal_columns = vim.o.columns
        end,
    })

    local function convert_to_pdf()
        local filepath = vim.fn.expand('%:p')

        if not filepath:match('%.md$') then
            print('Error: The current buffer must be a markdown file.')
            return
        end

        local output_file = filepath:gsub('%.md$', '.pdf')
        local cmd = string.format(
            'pandoc %s -f gfm --pdf-engine=xelatex --highlight-style kate -o %s && xdg-open %s',
            filepath,
            output_file,
            output_file
        )
        print(cmd)
        os.execute(cmd)
    end

    local function add_word_in_spellfile(word)
        local spellfiles = vim.fn.globpath(vim.o.runtimepath, 'spell/*.add', true, true)

        vim.ui.select(spellfiles, { prompt = 'Select spellfile' }, function(selected_spellfile)
            if not selected_spellfile then
                return
            end

            vim.opt.spellfile = selected_spellfile
            vim.cmd('silent spellgood ' .. word)
            vim.opt.spellfile = ''
        end)
    end

    local function md_code_action()
        local options = {
            'Spell suggestions',
            'Add word into dict',
            'Convert to pdf',
            'Code actions',
        }

        vim.ui.select(options, { prompt = 'Select Action' }, function(choice, index)
            if not choice then
                return
            end
            if index == 1 then
                telescope_builtin.spell_suggest()
            elseif index == 2 then
                local cursor_word = vim.fn.expand('<cword>')
                add_word_in_spellfile(cursor_word)
            elseif index == 3 then
                convert_to_pdf()
            else
                vim.lsp.buf.code_action()
            end
        end)
    end

    -- NOTE: subscribing here so it runs after the lsp config and overwrites the default mappings
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('markdown-code-actions', { clear = true }),
        callback = function(evt)
            keymaps.markdown(evt.buf, md_code_action)
        end,
    })
end

return M
