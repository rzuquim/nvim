local util = require('util')
local db_util = require('db.util')

local M = {}

function M.setup_dbui(dbs)
    local dev_pwd = util.local_dev_pwd()

    local dbs_stdout = util.run_cmd(
        'sqlcmd '
            .. '-S localhost '
            .. '-U sa '
            .. string.format('-P %s ', dev_pwd)
            .. '-d master '
            .. '-C '
            .. '-h -1 '
            .. '-Q "SET NOCOUNT ON; SELECT name FROM sys.databases WHERE database_id > 4"'
    )

    if not dbs_stdout then
        vim.notify('No user databases on localhost')
        return
    end

    local databases = {}
    for line in dbs_stdout:gmatch('[^\r\n]+') do
        if line then
            line = line:gsub('%s+', '')
            table.insert(databases, line)
        end
    end

    for _, db in ipairs(databases) do
        local conn_key = 'mssql@localhost:' .. db
        local conn_string = 'sqlserver://sa:' .. dev_pwd .. '@localhost:1433/' .. db .. '?trustServerCertificate'
        db_util.add_connection(conn_key, conn_string, dbs)
    end
end

return M
