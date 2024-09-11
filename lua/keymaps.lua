local util = require('util')

local function keymap(mode, key_combination, cmd, custom_opts)
    custom_opts = custom_opts or {}
    local opts = vim.tbl_deep_extend('force', custom_opts, {
        noremap = true, -- no recursive key bindings to avoid confusion
        silent = true, -- no output for each remap
    })

    vim.keymap.set(mode, key_combination, cmd, opts)
end

-- ----------------------
-- MISC
-- ----------------------
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap('n', '+', '<C-a>')
keymap('n', '-', '<C-x>')
keymap('n', 'Y', 'y$') -- make Y behave like D and C, yanking till end of line
keymap('n', 'X', '0d$jw') -- Erase line
keymap('n', ':', 'q:i') -- always open command mode with history
keymap('n', '/', 'q/i') -- always open command mode with history

-- ----------------------
-- Window management
-- ----------------------
keymap('n', '<C-k>', '<C-w>k') -- focus up
keymap('n', '<C-j>', '<C-w>j') -- focus down
keymap('n', '<C-h>', '<C-w>h') -- focus left
keymap('n', '<C-l>', '<C-w>l') -- focus right
keymap('n', '<A-->', ':vertical resize -2<CR>') -- resize left
keymap('n', '<A-+>', ':vertical resize +2<CR>') -- resize right
keymap('n', '<C-w>', util.close_curr_buffer) -- close buffer
keymap('n', '<leader>ww', ':wqa!<CR>') -- Quit everything writing all buffers to the disk
keymap('n', '<leader>we', ':%bd|e#<CR>') -- closes every buffer but the current one

-- ----------------------
-- Move lines
-- ----------------------
keymap('n', '<A-Up>', ':m .-2<CR>') -- move live up
keymap('n', '<A-Down>', ':m .+1<CR>') -- move live down
keymap('v', '<A-Up>', ":m '<-2<CR>gv=gv") -- move selection up
keymap('v', '<A-Down>', ":m '>+1<CR>gv=gv") -- move selection down

keymap('n', '<S-Tab>', '<<') -- untab with shift tab
keymap('i', '<S-Tab>', '<C-d>') -- untab with shift tab
keymap('v', '<Tab>', '>gv') -- tab in visual mode
keymap('v', '<S-Tab>', '<gv') -- untab in visual mode

keymap('v', '<leader>s', ':sort<CR>') -- sort the selected text
keymap('v', '<leader>u', ':sort u<CR>') -- eliminate duplicates and sort in the selected text

keymap('n', '<leader>xv', ':vsplit<CR>:bnext<CR>') -- vertical split
keymap('n', '<leader>xh', ':split<CR>:bnext<CR>') -- horizontal split

-- don't lose selection when indenting
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- ----------------------
-- File Management
-- ----------------------
keymap('n', '_', ':Oil<CR>') -- Opens Oil

-- ----------------------
-- Text Selection
-- ----------------------
keymap('n', 'vv', '^v$') -- select line
keymap('n', '<C-a>', 'GVgg') -- select all text

-- ----------------------
-- Navigation
-- ----------------------
keymap('n', '<S-l>', ':bnext<CR>')
keymap('n', '<S-h>', ':bprevious<CR>')

keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')

keymap('n', '<A-Left>', '<C-O>')
keymap('n', '<A-Right>', '<C-I>')

-- ----------------------
-- Issues
-- ----------------------
keymap('n', '<C-e>', vim.diagnostic.goto_prev)
keymap('n', '<C-E>', vim.diagnostic.goto_next)
keymap('n', '<leader>ee', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>')
keymap('n', '<leader>ew', '<cmd>Trouble diagnostics toggle<CR>')
keymap('n', '<leader>et', '<cmd>Trouble todo toggle<CR>')
keymap('n', '<leader>ef', vim.diagnostic.open_float)

local M = {}

function M.telescope(telescope_builtin, telescope_actions)
    keymap('n', '<C-p>', telescope_builtin.find_files)
    keymap('n', '<leader>/h', telescope_builtin.help_tags)
    keymap('n', '<leader>/k', telescope_builtin.keymaps)
    keymap('n', '<leader>/w', telescope_builtin.grep_string)
    keymap('n', '<leader>//', telescope_builtin.live_grep)
    keymap('n', '<leader>/d', telescope_builtin.diagnostics)
    keymap('n', '<leader>/t', ':TodoTelescope keywords=TODO,FIX,BUG,ISSUE,TEST<CR>')
    keymap('n', '<leader><leader>', telescope_builtin.buffers)

    -- NOTE: returns the keymaps inside the telescope prompt
    local common_bindings = {
        ['<C-n>'] = telescope_actions.cycle_history_next,
        ['<C-p>'] = telescope_actions.cycle_history_prev,

        ['<C-k>'] = telescope_actions.preview_scrolling_up,
        ['<C-j>'] = telescope_actions.preview_scrolling_down,

        ['<C-q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,

        ['<leader>xh'] = telescope_actions.select_horizontal,
        ['<leader>xv'] = telescope_actions.select_vertical,
    }

    return {
        i = common_bindings,

        n = vim.tbl_deep_extend('force', {}, common_bindings, {
            ['<ESC>'] = telescope_actions.close,
            ['<CR>'] = telescope_actions.select_default,

            ['<Down>'] = telescope_actions.move_selection_next,
            ['<Up>'] = telescope_actions.move_selection_previous,
            ['j'] = telescope_actions.move_selection_next,
            ['k'] = telescope_actions.move_selection_previous,
            ['gg'] = telescope_actions.move_to_top,
            ['G'] = telescope_actions.move_to_bottom,
        }),
    }
end

function M.oil()
    return {
        ['<CR>'] = 'actions.select',
        ['<A-v>'] = { 'actions.select', opts = { vertical = true } },
        ['<A-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<Esc>'] = { callback = 'actions.close', mode = 'n' },
        ['_'] = 'actions.parent',
        ['<C-_>'] = 'actions.open_cwd',
        ['<C-.>'] = 'actions.toggle_hidden',
        ['<A-p>'] = 'actions.preview',

        -- ["<C-l>"] = "actions.refresh",
        -- ["`"] = "actions.cd",
        -- ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        -- ["gs"] = "actions.change_sort",
        -- ["gx"] = "actions.open_external",
        -- ["g\\"] = "actions.toggle_trash",
    }
end

function M.lsp(buf)
    local telescope_builtin = require('telescope.builtin')
    local bufferScope = { buffer = buf }
    -- go to definition, usages, go to implementation and rename
    keymap('n', '<F12>', telescope_builtin.lsp_definitions, bufferScope)

    keymap('n', '<F36>', telescope_builtin.lsp_implementations, bufferScope)
    keymap('n', '<F2>', vim.lsp.buf.rename, bufferScope)
    keymap('n', '<F24>', telescope_builtin.lsp_references, bufferScope)

    -- signature and help
    keymap('n', '?', vim.lsp.buf.hover, bufferScope)
    keymap('n', '<leader>?', vim.lsp.buf.signature_help, bufferScope)
    keymap('n', '<C-.>', vim.lsp.buf.code_action, bufferScope)
end

function M.format(conform)
    keymap('n', '<leader>f', function()
        conform.format({ async = true, lsp_fallback = true })
    end)
end

function M.comments()
    return {
        toggler = {
            line = '<leader>cc',
            block = '<leader>cb',
        },
        opleader = {
            line = '<leader>cc',
            block = '<leader>cb',
        },
        extra = {
            above = '<leader>cO',
            below = '<leader>co',
            eol = '<leader>cA',
        },
    }
end

function M.git(buf, custom_toggle_blame)
    local gitsigns = require('gitsigns')
    local bufferScope = { buffer = buf }

    keymap('n', '<A-j>', gitsigns.next_hunk, bufferScope)
    keymap('n', '<A-k>', gitsigns.prev_hunk, bufferScope)
    keymap('n', '<leader>gs', gitsigns.preview_hunk, bufferScope)
    keymap('n', '<leader>gd', gitsigns.diffthis, bufferScope)
    keymap('n', '<leader>gb', custom_toggle_blame, bufferScope)
end

-- utils for snippet "super-tab" behavior
local check_backspace = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

function M.cmp(cmp, luasnip)
    return {
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),

        ['<Esc>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),

        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),

        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete({}),

        ['<Tab>'] = cmp.mapping(function(fallback) -- navigates through the snippet fields
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            'i',
            's',
        }),
        ['<S-Tab>'] = cmp.mapping(function(fallback) -- backwards fields navigation
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            'i',
            's',
        }),
    }
end

function M.harpoon()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", ",", ui.toggle_quick_menu)
    vim.keymap.set("n", ",,", mark.add_file)

    vim.keymap.set("n", ",f", function() ui.nav_file(1) end)
    vim.keymap.set("n", ",d", function() ui.nav_file(2) end)
    vim.keymap.set("n", ",s", function() ui.nav_file(3) end)
    vim.keymap.set("n", ",a", function() ui.nav_file(4) end)
end

return M
