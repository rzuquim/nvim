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
keymap('n', '+', '<C-a>')
keymap('n', '-', '<C-x>')
keymap('n', 'Y', 'y$') -- make Y behave like D and C, yanking till end of line
keymap('n', '<leader>y', '"sy') -- using register s for special stuff
keymap('n', '<leader>Y', '"sy$')
keymap('n', '<leader>p', '"sp')
keymap('n', '<leader>P', '"sP')
keymap('n', 'X', '0d$jw') -- Erase line
keymap('n', '<C-;>', 'q:i') -- cmd mode with history
keymap('n', '<C-/>', 'q/i') -- cmd mode with history
keymap('n', 'Q', 'qq^') -- i never use more than one macro and I dont quit with Q
keymap('n', '@', '@q')

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
keymap('n', '<Tab>', '<C-^>') -- toggle buffers
keymap('n', '<leader>ww', ':wqa!<CR>') -- Quit everything writing all buffers to the disk
keymap('n', '<leader>we', ':%bd|e#<CR>') -- closes every buffer but the current one
keymap('n', '<leader>wq', ':cclose<CR>') -- closes qflist

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

keymap('n', '<A-n>', ':cnext<CR>') -- next quickfix item
keymap('n', '<A-p>', ':cprev<CR>') -- previous quickfix item

-- ----------------------
-- Diagnostics
-- ----------------------
keymap('n', 'E', vim.diagnostic.goto_prev)
keymap('n', 'e', vim.diagnostic.goto_next)
keymap('n', '<leader>ee', '<cmd>Trouble diagnostics toggle<CR>')
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
    keymap('n', '<leader>/?', telescope_builtin.builtin)
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
    keymap('n', '<F24>', function()
        telescope_builtin.lsp_references({
            include_declaration = false,
            include_current_line = false,
        })
    end, bufferScope)

    -- signature and help
    keymap('n', '?', vim.lsp.buf.hover, bufferScope)
    keymap('n', '<leader>?', vim.lsp.buf.signature_help, bufferScope)
    keymap('n', 't', vim.lsp.buf.code_action, bufferScope)
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

function M.gitsigns(buf, custom_toggle_blame)
    local gitsigns = require('gitsigns')
    local bufferScope = { buffer = buf }

    keymap('n', '<A-j>', gitsigns.next_hunk, bufferScope)
    keymap('n', '<A-k>', gitsigns.prev_hunk, bufferScope)
    keymap('n', '<leader>gs', gitsigns.preview_hunk, bufferScope)
    keymap('n', '<leader>gd', gitsigns.diffthis, bufferScope)
    keymap('n', '<leader>gb', custom_toggle_blame, bufferScope)
end

function M.git_diff_view(actions)
    keymap('n', '<leader>g?', actions.toggle_git_diff_view)
    keymap('n', '<leader>/g', actions.custom_git_changed_files)
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

function M.multicursor(mc)
    keymap({ 'n', 'v' }, '<C-n>', function()
        mc.addCursor('*')
    end)

    keymap('n', '<ESC>', function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        elseif mc.hasCursors() then
            mc.clearCursors()
        end
        vim.cmd('nohlsearch')
    end)

    keymap('v', 'I', mc.insertVisual)
    keymap('v', 'A', mc.appendVisual)
    keymap('v', 'S', mc.splitCursors)
end

function M.lsp_lines(lsp_lines)
    keymap('n', '<leader>et', lsp_lines.toggle_lsp_lines)
end

function M.markdown(buf, code_action)
    local bufferScope = { buffer = buf }
    keymap('n', 'e', ']s', bufferScope)
    keymap('n', 'E', '[s', bufferScope)
    keymap('n', 't', code_action, bufferScope)
end

function M.dap(dapui, dap)
    keymap('n', '<F8>', dap.continue)
    keymap('n', '<F10>', dap.step_over)
    keymap('n', '<F11>', dap.step_into)
    keymap('n', '<F12>', dap.step_out)

    keymap('n', '<F9>', dap.toggle_breakpoint)
    keymap('n', '<C-F9>', dap.clear_breakpoints)

    keymap('n', '<leader>dd', dapui.toggle)
    keymap('n', '<Leader>dl', dap.run_last)
    keymap('n', '<leader>/b', ':Telescope dap list_breakpoints<CR>')
    -- :Telescope dap commands
    -- :Telescope dap configurations
    -- :Telescope dap variables
    -- :Telescope dap frames

    keymap('n', '<leader>dr', function()
        dapui.toggle({ reset = true }) -- resets the UI
    end)

    -- TODO: additional commands
    --      "<cmd>lua require'dap'.step_back()<cr>",
    --      "<cmd>lua require'dap'.run_to_cursor()<cr>",
    --      "<cmd>lua require'dap'.disconnect()<cr>",
    --      "<cmd>lua require'dap'.session()<cr>",
    --      "<cmd>lua require'dap'.pause()<cr>",
    --      "<cmd>lua require'dap'.repl.toggle()<cr>",
    --      "<cmd>lua require'dap'.close()<cr>",
end

return M
