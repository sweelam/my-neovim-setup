-- Set up lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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


vim.o.guifont = "monaco:h18"

-- Basic Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.api.nvim_set_keymap('n', '<A-H>', ':wincmd H<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-L>', ':wincmd L<CR>', { noremap = true, silent = true })

-- Set up plugins using lazy.nvim
require("lazy").setup({
    -- Theme: Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
            })
            vim.cmd.colorscheme "catppuccin"
        end,
    },

    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')

            -- Example LSP server setup
            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')

            -- Example LSP server setup
            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})
            lspconfig.jdtls.setup{
                cmd = {'/home/msweelam/.local/share/jdtls/bin/jdtls'},
                root_dir = lspconfig.util.root_pattern('.git', 'pom.xml', 'build.gradle'),
                settings = {
                    java = {
                        format = {
                            enabled = true,
                        },
                        saveActions = {
                            organizeImports = true,
                        },
                        completion = {
                            favoriteStaticMembers = {
                                "org.hamcrest.MatcherAssert.assertThat",
                                "org.hamcrest.Matchers.*",
                                "org.hamcrest.CoreMatchers.*",
                                "org.junit.jupiter.api.Assertions.*",
                                "java.util.Objects.requireNonNull",
                                "java.util.Objects.requireNonNullElse",
                                "org.mockito.Mockito.*"
                            },
                        },
                    }
                },
                init_options = {
                    bundles = {},
                },
            }
        end,
    },

    {
        "Chiel92/vim-autoformat",
        config = function()
            vim.g.formatdef_google_java_format = '"google-java-format -"'
            vim.g.formatters_java = {'google_java_format'}
            -- Auto-format on save
            vim.api.nvim_exec([[
            augroup fmt
                autocmd!
                autocmd BufWritePre *.java Autoformat
            augroup END
            ]], false)
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,  -- JavaScript/TypeScript/CSS/JSON
                    null_ls.builtins.diagnostics.eslint,  -- JavaScript/TypeScript
                    null_ls.builtins.formatting.black,  -- Python
                    null_ls.builtins.diagnostics.flake8,  -- Python
                    null_ls.builtins.formatting.stylua,  -- Lua
                    null_ls.builtins.diagnostics.luacheck,  -- Lua
                },
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-calc",  -- Calculator source
            "f3fora/cmp-spell",  -- Spell source
            "hrsh7th/cmp-nvim-lua",  -- nvim-lua API
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'spell' },
                    { name = 'calc' },
                    { name = 'nvim_lua' },
                })
            })
        end,
    },
    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "all",
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'catppuccin',
                },
            }
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim", tag = '0.1.1',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },

    -- Git integration
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup()
        end,
    },

    {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup{
            size = 15,  -- Size of the terminal (height for horizontal, width for vertical)
            open_mapping = [[<C-t>]],  -- Key mapping to toggle the terminal
            shade_filetypes = {},  -- Filetypes that will not have their background shaded
            shade_terminals = true,  -- Whether to shade terminal buffers
            shading_factor = 2,  -- Degree of shading (1 is light, 3 is dark)
            start_in_insert = false,  -- Start the terminal in insert mode
            insert_mappings = false,  -- Whether to apply the open mapping in insert mode
            terminal_mappings = true,  -- Whether to apply the open mapping in the terminal
            persist_size = true,  -- Whether to persist the size of the terminal
            direction = 'horizontal',  -- The direction the terminal opens: 'horizontal', 'vertical', 'float'
            close_on_exit = true,  -- Close the terminal window when the process exits
            shell = vim.o.shell,  -- Shell to use in the terminal
            float_opts = {  -- Options for floating terminal
                border = 'curved',  -- Border style: 'single', 'double', 'shadow', 'curved'
                winblend = 3,  -- Transparency of the floating window
            }
        }

        end,
    },

    -- C/C++ Language Server (clangd)
    {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.clangd.setup({
            cmd = { "clangd", "--background-index" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
                    or vim.loop.os_homedir(),
            settings = {
                clangd = {
                    completion = {
                        enable = true,
                    },
                    diagnostic = {
                        enable = true,
                    },
                },
            },
        })
    end,
    },

    -- ALE for linting and static analysis
    {
    "dense-analysis/ale",
    config = function()
        vim.g.ale_linters = {
            c = {'clang', 'gcc'},
            cpp = {'clang', 'gcc'},
        }
        vim.g.ale_fixers = {
            ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
            c = {'clang-format'},
            cpp = {'clang-format'},
        }
        vim.g.ale_fix_on_save = 1
    end,
    },

})

-- Additional settings or key mappings can go here
