return {
	{
		"renerocksai/telekasten.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		cmd = { "Telekasten" },
		keys = {
			{
				"<leader>zn",
				function()
					require("telekasten").new_note()
				end,
				desc = "New Note",
			},
			{
				"<leader>zN",
				function()
					require("telekasten").new_templated_note()
				end,
				desc = "New Templated Note",
			},
			{
				"<leader>zf",
				function()
					require("telekasten").find_notes()
				end,
				desc = "Find Notes",
			},
			{
				"<leader>zg",
				function()
					require("telekasten").search_notes()
				end,
				desc = "Search Notes",
			},
			{
				"<leader>zo",
				function()
					require("telekasten").panel()
				end,
				desc = "Notes Panel",
			},
			{
				"<leader>zt",
				function()
					require("telekasten").show_tags()
				end,
				desc = "Show Tags",
			},
			{
				"<leader>zd",
				function()
					require("telekasten").find_daily_notes()
				end,
				desc = "Find Daily Notes",
			},
			{
				"<leader>zb",
				function()
					require("telekasten").show_backlinks()
				end,
				desc = "Show Backlinks",
			},
			{
				"<leader>zl",
				function()
					require("telekasten").find_friends()
				end,
				desc = "Find Friends",
			},
			{
				"<leader>zm",
				function()
					require("telekasten").browse_media()
				end,
				desc = "Browse Media",
			},
		},
		opts = {
			home = vim.fn.expand("~/notes"),
			template_new_note = vim.fn.expand("~/notes/templates/new_note.md"),
			template_new_daily = vim.fn.expand("~/notes/templates/daily.md"),
			template_new_weekly = vim.fn.expand("~/notes/templates/weekly.md"),
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>z", group = "Notes", icon = "󰟶" },
			},
		},
	},
}
