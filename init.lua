require('options')
require('autocmds')
require('keymaps')

local plugins = require('plugin_manager')

plugins.setup('lsp_config')

plugins.setup('appearance.oil')
plugins.setup('appearance.theme')
plugins.setup('appearance.lualine')
plugins.setup('appearance.todo')
plugins.setup('appearance.treesitter')
plugins.setup('appearance.gitsigns')
plugins.setup('appearance.colorizer')

plugins.setup('behavior.telescope')
plugins.setup('behavior.conform')
plugins.setup('behavior.multi_cursor')
plugins.setup('behavior.autopairs')
plugins.setup('behavior.comments')
plugins.setup('behavior.auto_complete')
plugins.setup('behavior.mini_helpers')
plugins.setup('behavior.auto_save')

plugins.install()
