require('options')
require('autocmds')
require('keymaps')

local langs = require('langs')
local plugins = require('plugin_manager')

plugins.setup('lsp_config')

plugins.setup('appearance.oil')
plugins.setup('appearance.theme')
plugins.setup('appearance.lualine')
plugins.setup('appearance.todo')
plugins.setup('appearance.treesitter')
plugins.setup('appearance.gitsigns')
plugins.setup('appearance.gitdiffview')
plugins.setup('appearance.colorizer')
plugins.setup('appearance.dressing')
plugins.setup('appearance.indent_guides')
plugins.setup('appearance.trouble')
plugins.setup('appearance.lsp_lines')

plugins.setup('behavior.telescope')
plugins.setup('behavior.conform')
plugins.setup('behavior.lint')
plugins.setup('behavior.multi_cursor')
plugins.setup('behavior.autopairs')
plugins.setup('behavior.comments')
plugins.setup('behavior.auto_complete')
plugins.setup('behavior.mini_helpers')
plugins.setup('behavior.auto_save')
plugins.setup('behavior.tmux')
plugins.setup('behavior.workspace_diagnostics')

for _, plugin in pairs(langs.extra_plugins()) do
    plugins.setup(plugin, true)
end

plugins.install()

