return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "biome",
            },
        },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                ["javascript"] = { "biome" },
                ["javascriptreact"] = { "biome" },
                ["typescript"] = { "biome" },
                ["typescriptreact"] = { "biome" },
                ["json"] = { "biome" },
                ["jsonc"] = { "biome" },
            },
        },
    },
}
