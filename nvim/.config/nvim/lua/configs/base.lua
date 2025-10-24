-- Set <space> as the leader key.
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Do we use nerd font?
vim.g.have_nerd_font = true

-- Enable relative line numbers.
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line.
vim.o.showmode = false

-- Expand tabs to spaces.
vim.o.expandtab = true

-- Shift by characters.
vim.o.shiftwidth = 4

-- Set tabstop at.
vim.o.tabstop = 4

-- Enable break indent.
vim.o.breakindent = true

-- Save undo history.
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default.
vim.o.signcolumn = "yes"

-- Decrease update time.
vim.o.updatetime = 250

-- Decrease mapped sequence wait time.
vim.o.timeoutlen = 300

-- Configure how new splits should be opened.
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- NOTE: This does not mark indents made using spaces. For that we need another plugin.
vim.o.list = true
vim.opt.listchars = { tab = "┊ ", trail = "·", nbsp = "␣" }

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Preview substitutions live, as you type.
vim.o.inccommand = "split"

-- Show which line your cursor is on.
vim.o.cursorline = false

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- Show a column marker.
vim.o.colorcolumn = "70,80,100"

-- Set textwidth so comments can be reflowed easily.
vim.o.textwidth = 70

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
