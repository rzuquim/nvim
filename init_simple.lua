-- NOTE: this file is a simplified config without most plugins to use in git and diff mode

require('options')
require('autocmds')
require('keymaps')

local plugins = require('plugin_manager')

plugins.setup('appearance.theme')
plugins.setup('behavior.multi_cursor')
plugins.setup('behavior.mini_helpers')
plugins.setup('behavior.tmux')

plugins.install()

