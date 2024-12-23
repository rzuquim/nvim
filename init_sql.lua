-- NOTE: this file is a simplified config for accessing sql databases

require('options')
require('autocmds')
require('keymaps')
require('clipboard')

local plugins = require('plugin_manager')

plugins.setup('appearance.theme')
plugins.setup('appearance.lualine')

plugins.setup('behavior.multi_cursor')
plugins.setup('behavior.mini_helpers')
plugins.setup('behavior.telescope')
plugins.setup('behavior.tmux')

plugins.setup('db.vim_dadbod')

plugins.install()

local db = require('db')
db.setup()
db.start()
