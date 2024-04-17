-- [[[ OPTIONS ]]

-- Set leader key
vim.g.mapleader = ' '

-- Make line numbers default and set to relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Turn off line wrapping
vim.opt.wrap = false

-- Set tabs to 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Set incremental search
vim.opt.incsearch = false

-- Cursor remains above/below bottom/top of screen when scrolling
vim.opt.scrolloff = 8

-- Faster update time
vim.opt.updatetime = 50

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Display tabs with special character to distinguish from spaces
vim.opt.list = true
vim.opt.listchars = { tab = '» ' }


-- Column to indicate 80 line width
-- vim.opt.colorcolumn = "80"

-- Make cursor in insert mode fat
-- vim.opt.guicursor = ""



-- [[[ KEYMAPS ]]

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Completely clears search pattern instead
-- vim.keymap.set('n', '<Esc>', '<cmd>let @/ = ""<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })















































