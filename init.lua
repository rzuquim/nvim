require('options')
require('autocmds')

KEYMAPS = require('keymaps')
local plugins = require('plugin_manager')

plugins.setup('lsp_config')

plugins.setup('appearance.oil')
plugins.setup('appearance.theme')
plugins.setup('appearance.lualine')
plugins.setup('appearance.todo')

plugins.setup('behavior.telescope')
plugins.setup('behavior.conform')
plugins.setup('behavior.multi_cursor')
plugins.setup('behavior.autopairs')
plugins.setup('behavior.comments')

plugins.install()
