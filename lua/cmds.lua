local util = require('util')

vim.api.nvim_create_user_command('LineBreaksReplace', util.line_breaks_replace, {})
