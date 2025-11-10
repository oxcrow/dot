return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			color_overrides = {
				all = {},
				latte = {
					base = "#ffffff",

					text = "#1b1212",

					rosewater = "#000000",
					flamingo = "#000000",
					pink = "#ff00ff",
					mauve = "#000000",
					red = "#000000",
					maroon = "#000000",
					peach = "#000000",
					yellow = "#2986cc",
					green = "#9ae630",
					sapphire = "#000000",
					blue = "#1f51ff",
					lavender = "#5b6cca",
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
						["@type"] = { fg = colors.blue },
						["@constructor"] = { fg = colors.blue },
						["@module"] = { fg = colors.blue },
						["@string"] = { fg = colors.pink },
						["@keyword"] = { fg = colors.blue },
						["@variable"] = { fg = colors.text },
						["@constant"] = { fg = colors.text },
					}
				end,
			},
		})
	end,
}
