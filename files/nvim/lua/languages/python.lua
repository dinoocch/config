return {

    -- Python is included by default in treesitter
    -- {
    --   "nvim-treesitter/nvim-treesitter",
    --   opts = function(_, opts)
    --     if type(opts.ensure_installed) == "table" then
    --       vim.list_extend(opts.ensure_installed, { "python" })
    --     end
    --   end,
    -- },

    -- correctly setup lspconfig
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- make sure mason installs the server
            servers = {
                pyright = {},
            },
        },
    },
}