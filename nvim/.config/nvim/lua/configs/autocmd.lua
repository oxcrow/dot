vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.c", "*.h", "*.cc", ".hh" },
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.no",
	command = "setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.c", "*.h" },
	command = "setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.l", "*.y" },
	command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 syntax=c",
})
