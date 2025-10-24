return {
	"folke/noice.nvim",
	event = "VeryLazy", -- Lazy-load on startup
	opts = {}, -- Extend with your config below
	dependencies = {
		"MunifTanjim/nui.nvim", -- Required for rendering
		-- OPTIONAL: For notification view (falls back to mini if missing)
		"rcarriga/nvim-notify",
	},
}
