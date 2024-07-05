-- keymaps em arquivo só
-- lang => um arquivo (lsp, formatter?, treesitter, snippet?)

require("options")
require("keymaps")

local plugins = require("plugin_manager")

plugins.setup("appearance.oil")
plugins.setup("appearance.theme")
plugins.setup("appearance.lualine")

plugins.install()
