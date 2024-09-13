local M = {
    plugin_specs = {}
}

function M.setup(specs, literal)
    if literal then
        table.insert(M.plugin_specs, specs)
    else
        table.insert(M.plugin_specs, { import = specs })
    end
end

function M.install()
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(lazypath) then
        local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
        vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    end ---@diagnostic disable-next-line: undefined-field
    vim.opt.rtp:prepend(lazypath)

    require('lazy').setup(M.plugin_specs)
end

return M
