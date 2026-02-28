vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.c", "*.h", "*.cc", ".hh" },
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.nxn",
	command = "setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4",
})
