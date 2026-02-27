-- NOTE: for latex I got worse results with LSP than just installing the plugin
local M = {
    'lervag/vimtex',
    lazy = false,
    ft = { 'tex' },
}

function M.init()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtext_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
        out_dir = 'build',
        aux_dir = 'build',
    }

    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        callback = function()
            vim.cmd('syntax enable')
        end,
    })
end

return M
