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
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Go [D]own half a page'})
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Go [U]p half a page' })

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

    -- Language parser: Highlights code
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
            -- I actually prefer the way harpoon looks right now, so don't uncomment
            
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
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' }) 
            vim.keymap.set('n', '<leader>sg', builtin.git_files, { desc = '[S]earch [G]it' })
            vim.keymap.set('n', '<leader>sw', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end)
        end
    },


    -- LSP: Language Server Protocol
    -- Provides functionality to go to definition, autocompletion, find references, etc.
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim', opts = {} },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end

                    -- The following autocommand is used to enable inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })


            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            
            -- THESE 2 LINES ARE NOT WORKING
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- capabilities = vim.tbl_deep_extend('force', capabilities, require('hrsh7th/cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                basedpyright = {},
                rust_analyzer = {},
                r_language_server = {},
                -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }
            
            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install
            --  other tools, you can run
            --    :Mason
            --
            --  You can press `g?` for help in this menu.
            require('mason').setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
                'ruff', -- Used to format and lint python code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            -- require('mason-lspconfig').setup {
            --     handlers = {
            --         function(server_name)
            --             local server = servers[server_name] or {}
            --             -- This handles overriding only values explicitly passed
            --             -- by the server configuration above. Useful when disabling
            --             -- certain features of an LSP (for example, turning off formatting for tsserver)
            --             server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            --             require('lspconfig')[server_name].setup(server)
            --         end,
            --     },
            -- }
        end
    }
    

--     -- Autoformat
--     {
--     'stevearc/conform.nvim',
--     lazy = false,
--     keys = {
--         {
--             '<leader>f',
--             function()
--                 require('conform').format { async = true, lsp_fallback = true }
--             end,
--             mode = '',
--             desc = '[F]ormat buffer',
--         },
--     },
--     opts = {
--         notify_on_error = false,
--         format_on_save = function(bufnr)
--             -- Disable "format_on_save lsp_fallback" for languages that don't
--             -- have a well standardized coding style. You can add additional
--             -- languages here or re-enable it for the disabled ones.
--             local disable_filetypes = { c = true, cpp = true }
--             return {
--                 timeout_ms = 500,
--                 lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
--             }
--         end,
--         formatters_by_ft = {
--             lua = { 'stylua' },
--             -- Conform can also run multiple formatters sequentially
--             -- python = { "isort", "black" },
--             --
--             -- You can use a sub-list to tell conform to run *until* a formatter
--             -- is found.
--             -- javascript = { { "prettierd", "prettier" } },
--         },
--     },
-- },


})







