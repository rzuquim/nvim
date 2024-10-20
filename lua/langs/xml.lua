local M = {
    settings = {
        xml = {
            validation = {
                dtd = true,
                schema = true,
            },
            format = {
                -- TODO: disable when xmlformatter is working
                enabled = true,
            },
            server = {
                workDir = '~/.cache/lemminx',
            },
        },
    },
    -- TODO: enable when we can fix the error: 'xmlformatter unavailable: Formatter config missing or incomplete'
    -- extra_formatters = {
    --     xml = { 'xmlformatter' },
    --     config = { 'xmlformatter' },
    -- },
    extra_treesitter = {
        'xml',
    },
}

local ignored_extensions = { 'csproj' }

local function should_attach(extension)
    for _, ext in ipairs(ignored_extensions) do
        if extension == ext then
            return false
        end
    end
    return true
end

function M.on_attach(client)
    local file_extension = vim.fn.expand('%:e')
    if not should_attach(file_extension) then
        client.stop()
        return
    end
end

return M
