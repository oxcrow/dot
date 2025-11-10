return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8", -- Pin to stable version. Check GitHub for latest version.
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		-- Keymaps (add to your keymap setup or here)
		vim.keymap.set("n", "s", builtin.current_buffer_fuzzy_find, { desc = "[S]earch in current buffer" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find files with Grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find files in Buffers" })
		-- My personal keymaps
		vim.keymap.set("n", "<F3>", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find files in Buffers" })
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { ".git/", "build/", "zig-build/", "target/" },
			},
		})
	end,
}
