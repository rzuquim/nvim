local M = {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        'theHamsta/nvim-dap-virtual-text',
        'nvim-telescope/telescope-dap.nvim',
    },
    event = 'VeryLazy',
}

function M.config()
    local keymaps = require('keymaps')
    local icons = require('appearance.icons')
    local telescope = require('telescope')
    local langs = require('langs')

    local dap = require('dap')
    local dap_ui = require('dapui')
    local dap_virtual_text = require('nvim-dap-virtual-text')

    for _, debugger_config in ipairs(langs.extra_dap_config()) do
        debugger_config(dap)
    end

    dap_ui.setup()
    dap_virtual_text.setup({ virt_text_pos = 'eol' })

    telescope.load_extension('dap')

    -- NOTE: colors and icons
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'Error' })

    for name, sign in pairs(icons.dap) do
        vim.fn.sign_define(name, sign)
    end

    keymaps.dap(dap_ui, dap)

    -- NOTE: making sure dapui is open on a session is running
    dap.listeners.before.attach.dapui_config = dap_ui.open
    dap.listeners.before.launch.dapui_config = dap_ui.open
    dap.listeners.before.event_terminated.dapui_config = dap_ui.close
    dap.listeners.before.event_exited.dapui_config = dap_ui.close
end

return M
