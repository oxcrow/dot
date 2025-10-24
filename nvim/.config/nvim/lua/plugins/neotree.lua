return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- Optional, for icons
	},
	config = function()
		-- Optional: Open Neo-tree when Neovim starts in a directory
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[0]) then
					vim.cmd("Neotree")
				end
			end,
		})
	end,
	opts = {
		sources = { "filesystem", "buffers", "git_status" },
		window = {
			position = "left",
			width = 40,
			mappings = {
				["<cr>"] = "open",
				["a"] = "add",
				["d"] = "delete",
				["r"] = "rename",
				["R"] = "refresh",
				["?"] = "show_help",
			},
		},
		filesystem = {
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true, -- Auto-refresh
			filtered_items = {
				hide_dotfiles = true,
				hide_gitignored = true,
			},
		},
		rendering = {
			max_indent = 40, -- Adjust for deeper folders
		},
	},
}
