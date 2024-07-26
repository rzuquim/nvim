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
keymap('n', '<C-Up>', '<C-w>k') -- focus up
keymap('n', '<C-Down>', '<C-w>j') -- focus down
keymap('n', '<C-Left>', '<C-w>h') -- focus left
keymap('n', '<C-Right>', '<C-w>l') -- focus right
keymap('n', '<A-->', ':vertical resize -2<CR>') -- resize left
keymap('n', '<A-+>', ':vertical resize +2<CR>') -- resize right
keymap('n', '<C-w>', ':Bdelete!<CR>') -- close buffer
keymap('n', '<leader>ww', ':wqa!<CR>') -- Quit everything writing all buffers to the disk
keymap('n', '<leader>we', ':%bd|e#<CR>') -- closes every buffer but the current one

-- ----------------------
-- Move lines
-- ----------------------
keymap('n', '<A-Up>', ':m .-2<CR>') -- move live up
keymap('n', '<A-Down>', ':m .+1<CR>') -- move live down
keymap('v', '<A-Up>', ":m '<-2<CR>gv=gv") -- move selection up
keymap('v', '<A-Down>', ":m '>+1<CR>gv=gv") -- move selection down
keymap('x', '<A-k>', ":move '<-2<CR>gv-gv") -- move selection up
keymap('x', '<A-j>', ":move '>+1<CR>gv-gv") -- move selection down

keymap('n', '<S-Tab>', '<<') -- untab with shift tab
keymap('i', '<S-Tab>', '<C-d>') -- untab with shift tab
keymap('v', '<Tab>', '>gv') -- tab in visual mode
keymap('v', '<S-Tab>', '<gv') -- untab in visual mode

keymap('v', '<leader>s', ':Sort<CR>') -- sort the selected text
keymap('v', '<leader>u', ':Sort u<CR>') -- eliminate duplicates and sort in the selected text

keymap('n', '<A-v>', ':vsplit<CR>:bnext<CR>') -- vertical split
keymap('n', '<A-h>', ':split<CR>:bnext<CR>') -- horizontal split

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

-- issues
keymap('n', '<C-e>', vim.diagnostic.goto_prev)
keymap('n', '<C-E>', vim.diagnostic.goto_next)
keymap('n', '<leader>ee', vim.diagnostic.setloclist)
keymap('n', '<leader>ef', vim.diagnostic.open_float)

local M = {}

function M.telescope(telescope_builtin)
    keymap('n', '<C-p>', telescope_builtin.find_files, { desc = 'Search Files' })
    keymap('n', '<leader>/h', telescope_builtin.help_tags, { desc = 'Search [H]elp' })
    keymap('n', '<leader>/k', telescope_builtin.keymaps, { desc = 'Search [K]eymaps' })
    keymap('n', '<leader>/w', telescope_builtin.grep_string, { desc = 'Search [W]ord' })
    keymap('n', '<leader>//', telescope_builtin.live_grep, { desc = 'Search by Grep' })
    keymap('n', '<leader>/d', telescope_builtin.diagnostics, { desc = 'Search [D]iagnostics' })
    keymap('n', '<leader><leader>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
end

function M.oil()
    return {
        ['<CR>'] = 'actions.select',
        ['_'] = 'actions.parent',
        ['<A-v>'] = { 'actions.select', opts = { vertical = true } },
        ['<A-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-.>'] = 'actions.toggle_hidden', -- TODO: not working
        -- default
        ['g?'] = 'actions.show_help',
        ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
        -- ["<C-p>"] = "actions.preview",
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g\\'] = 'actions.toggle_trash',
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
    keymap('n', 'K', vim.lsp.buf.hover, bufferScope)
    keymap('n', '<C-k>', vim.lsp.buf.signature_help, bufferScope)
    keymap('n', '<C-.>', vim.lsp.buf.code_action, bufferScope)
end

return M
