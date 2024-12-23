local M = {}

local function already_registered(conn_key, dbs)
    for _, db in ipairs(dbs) do
        if db.name == conn_key then
            return true
        end
    end
    return false
end

function M.add_connection(conn_key, conn_string, dbs)
    if already_registered(conn_key, dbs) then
        vim.notify('db conn already exists: ' .. conn_key, vim.log.levels.ERROR)
        return
    end

    table.insert(dbs, { name = conn_key, url = conn_string })
end

return M
