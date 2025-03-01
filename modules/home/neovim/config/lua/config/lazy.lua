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
vim.g.lazyvim_json = vim.fn.stdpath("data") .. "/lazy/lazyvim.json"

-- TODO: There's no reason to do this, just use nix...
local is_darwin = vim.loop.os_uname().sysname == "Darwin"

require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- { import = "lazyvim.plugins.extras.coding.copilot" },
		{ import = "lazyvim.plugins.extras.dap.core" },
		{ import = "lazyvim.plugins.extras.test.core" },
		{ import = "lazyvim.plugins.extras.coding.yanky" },
		{ import = "lazyvim.plugins.extras.util.project" },

		-- { import = "lazyvim.plugins.extras.formatting.prettier" },
		-- { import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.lang.tailwind" },
		-- { import = "lazyvim.plugins.extras.lang.terraform" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		-- { import = "lazyvim.plugins.extras.lang.gleam" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.lang.nix" },
		-- { import = "lazyvim.plugins.extras.lang.java" },

		{ import = "plugins" },
		{ import = "languages" },

		{ "echasnovski/mini.pairs", enabled = false },
		-- Mason does not work with nixos, which is nbd to be honest...
		{ "williamboman/mason-lspconfig.nvim", enabled = is_darwin },
		{ "williamboman/mason.nvim", enabled = is_darwin },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	install = {
		colorscheme = { "catppuccin" },
	},
	checker = {
		enabled = true,
	},
	performance = {
		disabled_plugins = {
			"gzip",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	-- Use a path out of the nix store for the lock file
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
