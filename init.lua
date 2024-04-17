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

-- [[ Keymaps ]]

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

-- [[ Basic Autocommands ]]

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  To update plugins you can run
--    :Lazy update
--
require("lazy").setup({
    
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth', 

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} }


})



































