return {
	{
		"github/copilot.vim",
		lazy = false,
	},
	{
		"olimorris/codecompanion.nvim",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
		keys = {
			{
				"<leader>sa",
				"<cmd>CodeCompanionActions<cr>",
				noremap = true,
				silent = true,
				desc = "[S]earch Code Companion [A]ctions",
			},
			{
				"<leader>ct",
				"<cmd>CodeCompanionChat Toggle<cr>",
				noremap = true,
				desc = "Code Companion [C]hat [T]oggle",
			},
			{
				"<leader>ct",
				"<cmd>CodeCompanionChat<cr>",
				mode = "v",
				noremap = true,
				desc = "Code Companion [C]hat [T]oggle",
			},
			{
				"<leader>ce",
				"<cmd>CodeCompanion /explain<cr>",
				mode = "v",
				noremap = true,
				silent = true,
				desc = "[C]ode Companion [E]xplain",
			},
			{
				"<leader>cc",
				"<cmd>CodeCompanion<cr>",
				mode = { "n", "v" },
				noremap = true,
				desc = "Launch [C]ode [C]ompanion",
			},
		},
		opts = {
			send_code = true,
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
					model = "claude-3.5-sonnet",
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						model = {
							default = "claude-3.5-sonnet",
						},
					})
				end,
			},
		},
	},
	{
		"saghen/blink.cmp",
		optional = true,
		opts = {
			sources = {
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
		},
	},
}
