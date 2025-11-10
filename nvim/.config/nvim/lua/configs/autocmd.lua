vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.c", "*.h", "*.cc", ".hh" },
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})
