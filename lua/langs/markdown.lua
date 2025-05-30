local keymaps = require('keymaps')

local render = {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
}

local navigation = {
    'jakewvincent/mkdnflow.nvim',
    ft = 'markdown',
}

local emoji = {
    'allaman/emoji.nvim',
    ft = 'markdown',
}

local preview = {
    'brianhuster/live-preview.nvim',
    ft = 'markdown',
    config = function()
        require('livepreview.config').set({
            browser = 'bash ~/.config/nvim/sh/markdown_preview.sh ',
            picker = 'telescope',
            dynamic_root = false,
        })
    end,
}

local M = {
    extra_formatters = {
        markdown = { 'prettier' },
    },
    extra_plugins = {
        render,
        navigation,
        emoji,
        preview,
    },
}

function emoji.config()
    require('emoji').setup({})
end

function render.config()
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

    -- NOTE: enabling spell check when it matters
    vim.api.nvim_create_autocmd('BufWinEnter', {
        group = vim.api.nvim_create_augroup('markdown-setup', { clear = true }),
        callback = function()
            if vim.bo.filetype ~= 'markdown' then
                return
            end

            vim.opt_local.spell = true
            vim.opt_local.spelllang = 'en,es,br,names,acronyms'

            -- NOTE: the render-markdown plugin works better with 2 sized tabs
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2
        end,
    })

    local function write_today()
        local date = os.date('%Y-%m-%d')

        local _, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()

        local new_line = line:sub(1, col) .. date .. line:sub(col + 1)
        vim.api.nvim_set_current_line(new_line)
    end

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
            'Create a link',
            'Print Today (current day)',
            'Emoji',
            'Toggle preview',
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
            elseif index == 4 then
                vim.api.nvim_command('MkdnCreateLink')
            elseif index == 5 then
                write_today()
            elseif index == 6 then
                local ts = require('telescope').load_extension('emoji')
                ts.emoji()
            elseif index == 7 then
                if not require('livepreview').is_running() then
                    vim.api.nvim_command('LivePreview start')
                else
                    vim.api.nvim_command('LivePreview close')
                end
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

function navigation.config()
    require('mkdnflow').setup({
        modules = {
            buffers = true,
            conceal = true,
            links = true,
            cursor = true,
            paths = true,
            maps = true,
            tables = false,
            yaml = false,
            bib = false,
            folds = false,
            foldtext = false,
            lists = false,
            cmp = false,
        },
        mappings = {
            MkdnEnter = false,
            MkdnTab = false,
            MkdnSTab = false,
            MkdnNextLink = false,
            MkdnPrevLink = false,
            MkdnNextHeading = false,
            MkdnPrevHeading = false,
            MkdnGoBack = false,
            MkdnGoForward = false,
            MkdnCreateLink = false,
            MkdnCreateLinkFromClipboard = false,
            MkdnFollowLink = false,
            MkdnDestroyLink = false,
            MkdnTagSpan = false,
            MkdnMoveSource = false,
            MkdnYankAnchorLink = false,
            MkdnYankFileAnchorLink = false,
            MkdnIncreaseHeading = false,
            MkdnDecreaseHeading = false,
            MkdnToggleToDo = false,
            MkdnNewListItem = false,
            MkdnNewListItemBelowInsert = false,
            MkdnNewListItemAboveInsert = false,
            MkdnExtendList = false,
            MkdnUpdateNumbering = false,
            MkdnTableNextCell = false,
            MkdnTablePrevCell = false,
            MkdnTableNextRow = false,
            MkdnTablePrevRow = false,
            MkdnTableNewRowBelow = false,
            MkdnTableNewRowAbove = false,
            MkdnTableNewColAfter = false,
            MkdnTableNewColBefore = false,
            MkdnFoldSection = false,
            MkdnUnfoldSection = false,
        },
    })
end

return M
