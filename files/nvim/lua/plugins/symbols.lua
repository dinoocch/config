return {
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        opts = {},
        keys = {
            {
                "<leader>fs",
                function()
                    require("symbols-outline").toggle_outline()
                end,
                desc = "Toggle Symbols Outline",
            },
        },
        deactivate = function()
            require("symbols-outline").close_outline()
        end,
    },
}
