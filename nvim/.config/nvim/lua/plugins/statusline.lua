local M = {
	"beauwilliams/statusline.lua",
	dependencies = {
		"nvim-lua/lsp-status.nvim",
	},
	config = function()
		require("statusline").setup({
			match_colorscheme = true,
			tabline = true,
			lsp_diagnostics = true,
			ale_diagnostics = false,
		})
	end,
}

return {}
