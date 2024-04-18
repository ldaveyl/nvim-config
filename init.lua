-- [[ OPTIONS ]]

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

-- Automatically indent next line and do it depending on context
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Set incremental search
vim.opt.incsearch = false

-- Cursor doesn't stick to end of screen when scrolling
vim.opt.scrolloff = 8

-- Faster update time
vim.opt.updatetime = 100

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Display tabs with special character to distinguish from spaces
vim.opt.list = true
vim.opt.listchars = { tab = '» ' }

-- Adds additional column to the left for marks
vim.opt.signcolumn = "yes"

-- Sync clipboard between OS and Neovim.
-- Is making neovim extremely laggy currently, so don't use
-- To make this work for Ubuntu WSL2, download win32yank.exe and place on path
-- See https://github.com/microsoft/WSL/issues/4440#issuecomment-638956838
-- vim.opt.clipboard = 'unnamedplus'

-- Column to indicate 80 line width
-- vim.opt.colorcolumn = "80"

-- Make cursor in insert mode fat
-- vim.opt.guicursor = ""


-- [[ Keymaps ]]

-- Center cursor after scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

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
    
    -- Comment visual regions/lines
    -- Only load when opening a buffer right before opening or creating a file
    { 
        'numToStr/Comment.nvim', 
        opts = {
            event = { "BufReadPre", "BufNewFile" }
        } 
    },

    -- Language parser
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate', -- Ensures that all installed parsers are updated to the latest version on build 
        opts = {
             ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "python", "html", "css", "json", "dockerfile", "r", "bash" },

             -- Install parsers synchronously (only applied to `ensure_installed`)
             sync_install = false,

             -- Automatically install missing parsers when entering buffer
             auto_install = true,

             highlight = {
                 enable = true,
                 additional_vim_regex_highlighting = false,
             },
        }
    },


    -- Harpoon: jump quickly between files
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require('harpoon')
            harpoon:setup()
            vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end) 
            vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end)
            vim.keymap.set('n', '<C-j>', function() harpoon:list():select(2) end)
            vim.keymap.set('n', '<C-k>', function() harpoon:list():select(3) end)
            vim.keymap.set('n', '<C-l>', function() harpoon:list():select(4) end)
        
            -- This small section here makes it so we use the UI from telescope to switch between files
            -- local conf = require("telescope.config").values
            -- local function toggle_telescope(harpoon_files)
            --     local file_paths = {}
            --     for _, item in ipairs(harpoon_files.items) do
            --         table.insert(file_paths, item.value)
            --     end
            --
            --     require("telescope.pickers").new({}, {
            --         prompt_title = "Harpoon",
            --         finder = require("telescope.finders").new_table({
            --             results = file_paths,
            --         }),
            --         previewer = conf.file_previewer({}),
            --         sorter = conf.generic_sorter({}),
            --     }):find()
            -- end
            --
            -- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" }) 

        end
    },
    
    -- Telescope: fuzzy finder
    -- Scroll through preview with <C-d> and <C-u>
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>ss', builtin.find_files) 
            vim.keymap.set('n', '<leader>sg', builtin.git_files, {})
            vim.keymap.set('n', '<leader>sw', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end)
        end
    },
    
    -- Detect tabstop and shiftwidth automatically
    -- 'tpope/vim-sleuth', 
    
    -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
    --     'lewis6991/gitsigns.nvim',
    --     opts = {
    --         signs = {
    --             add = { text = '+' },
    --             change = { text = '~' },
    --             delete = { text = '_' },
    --             topdelete = { text = '‾' },
    --             changedelete = { text = '~' },
    --         },
    --     },
    -- },



})



































