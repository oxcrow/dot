local M = {
	"gelguy/wilder.nvim",
	event = { "CmdlineEnter" }, -- Lazy-load on command mode
	config = function()
		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer({
				highlighter = wilder.basic_highlighter(),
				pumblend = 20,
			})
		)
		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.cmdline_pipeline({
					fuzzy = 1,
					fuzzy_filter = wilder.lua_fzy_filter(),
				}),
				wilder.vim_search_pipeline()
			),
		})
	end,
	dependencies = { "romgrk/fzy-lua-native" }, -- Optional for faster fuzzy
}
return M
