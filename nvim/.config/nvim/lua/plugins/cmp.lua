return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer", -- Load words from buffers
	},

	config = function()
		local cmp = require("cmp")

		cmp.setup.filetype({ "markdown", "plaintex", "txt" }, {
			-- No snippets, no LSP, no extras — just buffer words
			sources = {
				{ name = "buffer" },
			},

			-- Very simple mapping: Tab to accept, Ctrl+Space to trigger
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<cr>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.abort(),
			}),

			-- Don't auto-select first item (less annoying for prose)
			preselect = false,
		})
	end,
}
