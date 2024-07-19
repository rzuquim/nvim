-- keymaps em arquivo só
-- lang => um arquivo (lsp, formatter?, treesitter, snippet?)
-- TODO: multi_cursor

require("options")
KEYMAPS = require("keymaps")
local plugins = require("plugin_manager")

plugins.setup("lsp_config")

plugins.setup("appearance.oil")
plugins.setup("appearance.theme")
plugins.setup("appearance.lualine")

plugins.setup("behaviors.telescope")
-- plugins.setup("langs.conform")

plugins.install()

