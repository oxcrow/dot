return {
	"pocco81/true-zen.nvim",
	config = function()
		require("true-zen").setup({
			modes = {
				ataraxis = {
					minimum_writing_area = {
						width = 40,
						height = 45,
					},
					padding = {
						left = 50,
						right = 75,
					},
				},
				minimalist = {
					options = {
						number = false,
						relativenumber = false,
						ruler = true,
					},
				},
			},
		})
	end,
}
