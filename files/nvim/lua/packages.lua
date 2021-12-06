local packerDir = os.getenv('HOME') .. '/.local/share/nvim/site/pack/packer/opt/packer.nvim'


vim.o.termguicolors = true

if vim.fn.isdirectory(packerDir) == 0 then
    vim.fn.mkdir(packerDir, 'p')
    os.execute('git clone https://github.com/wbthomason/packer.nvim \'' .. packerDir .. '\'')
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Manage packer updates
    use {'wbthomason/packer.nvim', opt = true }

    -- Gruvbox Theme
    use {
        'npxbr/gruvbox.nvim',
        requires = { 'rktjmp/lush.nvim' },
        config = function()
            vim.o.background = 'dark'
            vim.cmd([[colorscheme gruvbox]])
        end
    }

    -- Lua Statusline
    use {
        'Famiu/feline.nvim',
        config = function() require'config.statusline' end,
        requires = {
            {'kyazdani42/nvim-web-devicons'},
            {'lewis6991/gitsigns.nvim'},
            {'SmiteshP/nvim-gps'},
        }
    }

    use {
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-gps").setup {
                languages = {
                    ["lua"] = false
                }
            }
        end
    }

    -- Colorize hexcolors like #faf000 everywhere
    use {
        'norcalli/nvim-colorizer.lua',
        config = function() require'colorizer'.setup() end
    }

    -- Use treesitter for colors
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                    highlight = { enable = true },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = 'gnn',
                            node_incremental = 'grn',
                            scope_incremental = 'grc',
                            node_decremental = 'grm',
                        },
                    },
                    indent = { enable = true }
                })
        end
    }

    use {
        'p00f/nvim-ts-rainbow',
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function() require('nvim-treesitter.configs').setup {
                rainbow = {
                    enable = true
                }
        } end
    }

    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append("eol:↴")
            require("indent_blankline").setup {
                show_end_of_line = true,
                -- space_char_blankline = " ",
                -- show_current_context = true,
                -- show_current_context_start = true,
            }
        end
    }

    -- Improved terminal support
    -- TODO: Consider akinsho/nvim-toggleterm.lua
    use {
        'kassio/neoterm',
        config = function()
            vim.g.neoterm_autoscroll = 1
            vim.g.neoterm_default_mod = 'belowright'
            vim.g.neoterm_size = 16
        end
    }

    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            vim.g.nvim_tree_git_hl = 1
            require('nvim-tree').setup {
                open_on_setup = false,
                auto_close = true,
                git = {
                    enable = true,
                    ignore = true,
                },
                filters = {
                    custom = {'.git', 'node_modules', '.cache'}
                }
            }
            vim.api.nvim_set_keymap('n', '<leader>nt', '<cmd>NvimTreeToggle<CR>', {noremap = true, silent = true})
        end
    }

    -- Git extensions
    use {
        'tpope/vim-fugitive',
        config = function()
            vim.api.nvim_exec([[augroup fugitive
            autocmd!
            autocmd BufReadPost fugitive://* set bufhidden=delete
                augroup END]], false)
        end
    }
    use {
        'tpope/vim-rhubarb',
        requires = {'tpop/vim-fugitive'}

    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function() require('gitsigns').setup() end
    }

    -- Allow renaming files with :rename <newname>
    use 'danro/rename.vim'

    -- chdir to a 'root' directory when editing
    use 'airblade/vim-rooter'

    -- Pretty fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = function()
            if vim.fn.executable('fd') then
                vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope fd<CR>', {noremap = true, silent = true})
            else
                vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files<CR>', {noremap = true, silent = true})
            end

            vim.api.nvim_set_keymap('n', '<leader>s', '<cmd>Telescope live_grep<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', {noremap = true, silent = true})


        end
    }

    use {
        'akinsho/nvim-bufferline.lua',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function() require'bufferline'.setup() end
    }

    -- Guess at indentation settings from the file
    -- TODO: Figure out treesitter indent
    use 'tpope/vim-sleuth'

    -- Comment stuff out
    use {
        'terrortylor/nvim-comment',
        config = function() require'nvim_comment'.setup() end
    }

    -- Operators for surrounding text
    use 'tpope/vim-surround'

    -- Sneak operator s{char}{char}
    use 'justinmk/vim-sneak'

    -- Useful bracket bindings
    use 'tpope/vim-unimpaired'

    -- Easily align things (most of this is probably done with a fixer though?)
    use {
        'junegunn/vim-easy-align',
        config = function()
            -- map('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})
            -- map('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})
        end
    }

    -- Secure modelines
    use 'ciaranm/securemodelines'

    -- lsp
    use {
        'neovim/nvim-lspconfig',
        config = function() require'config.lsp' end
    }

    use {
        'folke/trouble.nvim',
        config = function()
            require("trouble").setup({})
            vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
              {silent = true, noremap = true}
            )
            vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>",
              {silent = true, noremap = true}
            )
            vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>",
              {silent = true, noremap = true}
            )
            vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
              {silent = true, noremap = true}
            )
            vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
              {silent = true, noremap = true}
            )
            vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
              {silent = true, noremap = true}
            )
        end
    }

    -- completion
    use {
        'ms-jpq/coq_nvim',
        requires = {'ms-jpq/coq.artifacts', 'ms-jpq/coq.thirdparty'},

        config = function()
            vim.o.completeopt="menuone,noinsert,noselect"
            vim.o.shortmess = vim.o.shortmess .. "c"
            vim.g.coq_settings = { auto_start = "shut-up" }
            require("coq_3p") {
                { src = "nvimlua", short_name = "nLUA" },
                { src = "vimtex", short_name = "vTEX" },
                { src = "bc", short_name = "MATH", precision = 6 },
                { src = "copilot", short_name = "COP", tmp_accept_key = "<c-r>" },
            }
            local function t(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end


            function _G.smart_tab()
                return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
            end
            vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
        end
    }

    -- dap
    use {
        'mfussenegger/nvim-dap',
        config = function()
            -- Toggle breakpoints
            vim.api.nvim_set_keymap('n', '<leader>db', [[<Cmd>lua require('dap').toggle_breakpoint()<CR>]], {noremap = true, silent = true})
            -- Continue
            vim.api.nvim_set_keymap('n', '<leader>dc', [[<Cmd>lua require('dap').continue()<CR>]], {noremap = true, silent = true})
            -- Step over
            vim.api.nvim_set_keymap('n', '<leader>do', [[<Cmd>lua require('dap').step_over()<CR>]], {noremap = true, silent = true})
            -- Step into
            vim.api.nvim_set_keymap('n', '<leader>di', [[<Cmd>lua require('dap').step_into()<CR>]], {noremap = true, silent = true})
            -- Open repl
            vim.api.nvim_set_keymap('n', '<leader>dr', [[<Cmd>lua require('dap').repls.open()<CR>]], {noremap = true, silent = true})
        end
    }

    use {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
            vim.g.dap_virtual_text = true
        end
    }

    -- More syntaxes
    use 'sheerun/vim-polyglot'

    -- Prettier wildmenu
    use {
        'gelguy/wilder.nvim',
        requires = {
            -- This is a hack which only works because fzy-lua-native commits built artifacts...
            'romgrk/fzy-lua-native',
            'kyazdani42/nvim-web-devicons'
        },
        config = function()
            -- " For lua_fzy_highlighter   : requires fzy-lua-native vim plugin found
            vim.cmd [[
                call wilder#setup({'modes': [':', '/', '?']})
                call wilder#set_option('use_python_remote_plugin', 0)
                call wilder#set_option('pipeline', [
                      \   wilder#branch(
                      \     wilder#cmdline_pipeline({
                      \       'fuzzy': 1,
                      \       'fuzzy_filter': wilder#lua_fzy_filter(),
                      \     }),
                      \     wilder#vim_search_pipeline(),
                      \   ),
                      \ ])
                call wilder#set_option('renderer', wilder#renderer_mux({
                      \ ':': wilder#popupmenu_renderer({
                      \   'highlighter': wilder#lua_fzy_highlighter(),
                      \   'left': [
                      \     ' ',
                      \     wilder#popupmenu_devicons(),
                      \   ],
                      \   'right': [
                      \     ' ',
                      \     wilder#popupmenu_scrollbar(),
                      \   ],
                      \ }),
                      \ '/': wilder#wildmenu_renderer({
                      \   'highlighter': wilder#lua_fzy_highlighter(),
                      \ }),
                      \ }))
            ]]
        end
    }

    use {
        'ggandor/lightspeed.nvim',
        requires = {'tpope/vim-repeat'}
    }
end)
