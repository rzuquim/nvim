return {
    setup = function()
        local db_path = vim.fn.stdpath('config') .. '/lua/db'
        local pattern = '^conn_.*%.lua$'

        local handle = vim.loop.fs_scandir(db_path)
        if not handle then
            vim.notify('cannot get dir handle for ' .. db_path, vim.log.levels.ERROR)
            return
        end

        local dbs = {}
        while true do
            local name = vim.loop.fs_scandir_next(handle)
            if not name then
                break
            end

            if name:match(pattern) then
                local module_name = 'db.' .. name:gsub('%.lua$', '')
                local ok, module = pcall(require, module_name)

                if ok and type(module.setup_dbui) == 'function' then
                    module.setup_dbui(dbs)
                elseif not ok then
                    vim.notify('Failed to load db conn: ' .. module_name .. '\n' .. module, vim.log.levels.ERROR)
                end
            end
        end
        vim.g.dbs = dbs
    end,

    start = function()
        vim.cmd('DBUI')
    end,
}
