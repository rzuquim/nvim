local keymaps = require('keymaps')

local function set_hl(buf, ns, line, start_col, end_col, hl_group)
    vim.api.nvim_buf_set_extmark(buf, ns, line, start_col, {
        end_col = end_col,
        hl_group = hl_group,
        strict = false,
    })
end

local function paint_buf_info(buf, lsp_status, has_ts, has_fmt)
    local ns = vim.api.nvim_create_namespace('BufInfo')

    set_hl(buf, ns, 0, 0, -1, 'Title')
    set_hl(buf, ns, 1, 0, -1, 'Comment')
    set_hl(buf, ns, 6, 0, -1, 'Comment')

    for i = 2, 5 do
        set_hl(buf, ns, i, 1, 15, 'Label')
    end

    set_hl(buf, ns, 2, 16, -1, 'String') -- Type
    set_hl(buf, ns, 3, 16, -1, lsp_status ~= 'None' and 'DiagnosticInfo' or 'DiagnosticError')
    set_hl(buf, ns, 4, 16, -1, has_ts and 'DiagnosticOk' or 'DiagnosticError')
    set_hl(buf, ns, 5, 16, -1, has_fmt and 'DiagnosticHint' or 'Comment')
end

local function buf_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype

    -- =============
    -- LSP attached
    -- =============
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local lsp_names = vim.iter(clients)
        :map(function(client)
            return client.name
        end)
        :totable()
    local lsp_status = #lsp_names > 0 and table.concat(lsp_names, ', ') or 'None'

    -- =============
    -- Tree-sitter Status
    -- =============
    local ts_status = 'Inactive'
    local has_parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
    local has_ts = false
    if has_parser then
        ts_status = 'Active (' .. ft .. ')'
        has_ts = true
    end

    -- =============
    -- Conform Status
    -- =============
    local conform_ok, conform = pcall(require, 'conform')
    local fmt_status = 'Not Installed'
    local has_fmt = false
    if conform_ok then
        local formatters = conform.list_formatters(bufnr)
        if #formatters > 0 then
            local names = vim.iter(formatters)
                :map(function(f)
                    return f.name
                end)
                :totable()
            fmt_status = table.concat(names, ', ')
            has_fmt = true
        end
    end

    local content = {
        '   Current Buffer Info ',
        ' ' .. string.rep('━', 26),
        string.format(' 󰈔 Type:       %s', ft),
        string.format(' 󱐋 LSP:        %s', lsp_status),
        string.format(' 󰡄 TS:         %s', ts_status),
        string.format(' 󰉼 Conform:    %s', fmt_status),
        ' ' .. string.rep('━', 26),
    }

    local info_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(info_buf, 0, -1, false, content)
    paint_buf_info(info_buf, lsp_status, has_ts, has_fmt)

    vim.api.nvim_open_win(info_buf, true, {
        relative = 'editor',
        width = 40,
        height = #content,
        row = (vim.o.lines - #content) / 2,
        col = (vim.o.columns - 40) / 2,
        style = 'minimal',
        border = 'rounded',
        title = ' [System Status] ',
        title_pos = 'center',
    })
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = info_buf, silent = true })
    vim.api.nvim_create_autocmd('BufLeave', {
        buffer = info_buf,
        once = true,
        callback = function()
            pcall(vim.api.nvim_win_close, 0, true)
        end,
    })
end

vim.api.nvim_create_user_command('BufInfo', buf_info, { desc = 'Curr buffer info' })
keymaps.buffer(buf_info)
