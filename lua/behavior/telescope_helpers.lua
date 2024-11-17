local util = require('util')

local M = {}

M.cmd_picker = function(cmd, opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions_state = require('telescope.actions.state')
    local actions = require('telescope.actions')
    local conf = require('telescope.config').values

    local cmd_stdout = util.run_cmd(cmd)
    if not cmd_stdout then
        vim.notify('Err: could not run cmd: ' .. cmd)
        return nil
    end

    local entries = {}
    for line in cmd_stdout:gmatch('[^\r\n]+') do
        if opts.parse_line then
            table.insert(entries, opts.parse_line(line))
        else
            table.insert(entries, line)
        end
    end

    local co = nil
    local custom_mappings = nil
    if opts.custom_select then
        co = coroutine.running()
        local custom_select = function(prompt_bufnr)
            local selected_entry = actions_state.get_selected_entry()
            opts.custom_select(selected_entry)
            actions.close(prompt_bufnr)
            coroutine.resume(co, selected_entry)
        end

        custom_mappings = function(_, map)
            map('n', '<CR>', custom_select)
            map('i', '<CR>', custom_select)
            return true
        end
    end

    local picker_opts = {
        prompt_title = opts.prompt_title,
        finder = finders.new_table({
            results = entries,
            entry_maker = opts.entry_maker,
        }),
        sorter = opts.sorter or conf.generic_sorter({}),
        previewer = opts.previewer,
        attach_mappings = custom_mappings,
    }

    pickers.new({}, picker_opts):find()

    return co
end

M.max_size_previewer = function(native_previwers)
    local safe_to_preview = native_previwers.buffer_previewer_maker
    return function(filepath, bufnr, opts)
        opts = opts or {}

        filepath = vim.fn.expand(filepath)

        local small_safe_file = 1 * 1024 -- 1KB
        local max_size_in_bytes = 200 * 1024 -- 200KB

        vim.loop.fs_stat(filepath, function(_, stat)
            if not stat or stat.size > max_size_in_bytes then
                -- TODO: print file is too big
                return
            end

            if stat.size < small_safe_file then
                safe_to_preview(filepath, bufnr, opts)
            end

            vim.loop.fs_open(filepath, 'r', 438, function(err, fd)
                if err then
                    -- NOTE: Ensure the file descriptor is closed in case of error
                    vim.loop.fs_close(fd)
                    return
                end

                -- NOTE: reading the last bytes of the file to check if it is a minified file (looking for line breaks)
                local min_line_breaks = 3
                local tail_size = small_safe_file
                local offset = math.max(0, stat.size - tail_size)

                vim.loop.fs_read(fd, tail_size, offset, function(err_read, data)
                    vim.loop.fs_close(fd)
                    if err_read or not data then
                        return
                    end

                    local _, line_break_count = data:gsub('\n', '')
                    if line_break_count < min_line_breaks then
                        return
                    end

                    safe_to_preview(filepath, bufnr, opts)
                end)
            end)
        end)
    end
end

return M
