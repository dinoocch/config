return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			vim.lsp.enable("java_lsp")
		end,
		opts = {
			servers = {
				jdtls = { enabled = false },
			},
		},
	},
}
