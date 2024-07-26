-- LEADER KEY
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true -- use nerd font with fancy icons

-- :help options
local options = {
    expandtab = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    backup = false, -- do not create a backup file (we are mostly using git and undodir)
    clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
    cmdheight = 0, -- hide command line when not used
    completeopt = { 'menuone', 'noselect' }, -- mostly just for cmp (auto-complete plugin)
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = 'utf-8', -- the encoding written to a file
    mouse = 'a', -- allow the mouse to be used in neovim
    pumheight = 10, -- pop up menu height
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    showtabline = 0, -- hide tab line (data already on the lua line in the bottom)
    smartindent = true, -- make indenting smarter again
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- creates a swapfile
    timeoutlen = 700, -- time to wait for a mapped sequence to complete (in milliseconds)
    writebackup = false, -- blocks edition if a file is being edited by another program
    cursorline = true, -- highlight the current line
    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    numberwidth = 3, -- set number column width to 2 {default 4}
    signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
    wrap = false, -- display lines as one long line
    scrolloff = 8, -- always at least 8 lines when scrolling down
    sidescrolloff = 8, -- always at least 8 columns when scrolling left
    colorcolumn = '120', -- marker to set the desired max length

    undofile = true, -- persist undo history

    termguicolors = true, -- i like good colors
    updatetime = 300, -- and fast update times

    list = true, -- show redundant spaces
    listchars = { tab = '» ', trail = '·', nbsp = '.' },

    breakindent = true, -- break lines out of identation

    ignorecase = true, -- case on searches
    smartcase = true, -- we want to be smart

    inccommand = 'split', -- preview substitutions live, as you type!
    hlsearch = true, -- highlight on search, but clear on pressing <Esc> in normal mode
}

if vim.fn.has 'win32' == 1 then
  options.undodir = os.getenv("APPDATA") .. "/.vim/undodir"
else
  options.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

-- reading every options prop and setting into the action vim.opt
for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.shortmess:append('c') -- avoid prompts on auto-complete mistakes
