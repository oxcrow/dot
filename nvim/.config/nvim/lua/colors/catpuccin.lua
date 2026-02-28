return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			styles = {
				keywords = { "italic" },
			},
			color_overrides = {
				all = {},
				latte = {
					base = "#deded1",
					text = "#1b1212",

					rosewater = "#000000",
					flamingo = "#000000",
					pink = "#ff00ff",
					mauve = "#000000",
					red = "#000000",
					maroon = "#000000",
					peach = "#000000",
					yellow = "#2986cc",
					-- green = "#706d54",
					green = "#696969",
					sapphire = "#000000",
					-- blue = "#1f51ff",
					-- blue = "#1a2ca3",
					blue = "#2845d6",
					lavender = "#000000",
					sky = "#000000",
				},
				frappe = {},
				macchiato = {},
				mocha = {},
			},
			highlight_overrides = {
				latte = function(colors)
					return {
						["@function"] = { fg = colors.blue },
						["@type"] = { fg = colors.text },
						["@constructor"] = { fg = colors.text },
						["@module"] = { fg = colors.text },
						["@string"] = { fg = colors.blue },
						["@keyword"] = { fg = colors.green },
						["@variable"] = { fg = colors.text },
						["@constant"] = { fg = colors.text },
					}
				end,
			},
			integrations = {
				treesitter = true,
			},
		})
	end,
}
