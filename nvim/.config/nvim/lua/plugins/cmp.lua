return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer", -- Load words from buffers
		"amarakon/nvim-cmp-buffer-lines", -- Load words from buffers except comments (sketchy!)
	},

	config = function()
		local cmp = require("cmp")

		-- START Vibe coded slop
		--
		local buffer_no_comments = {}

		buffer_no_comments.new = function()
			return setmetatable({}, { __index = buffer_no_comments })
		end

		buffer_no_comments.get_keyword_pattern = function()
			return [[\k\+]]
		end

		buffer_no_comments.complete = function(_, params, callback)
			local bufnr = params.bufnr or vim.api.nvim_get_current_buf()
			local items = {}
			local seen = {}

			local min_len = 1
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

			-- Try to get Treesitter parser (core Neovim, no extra plugin needed)
			local use_ts = false
			local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr)
			if parser_ok and parser then
				use_ts = true
			end

			for lnum, line in ipairs(lines) do
				local pos = 1
				while true do
					local start_col, end_col = line:find("[%w_]+", pos)
					if not start_col then
						break
					end
					local word = line:sub(start_col, end_col)
					if #word >= min_len and not seen[word] then
						local is_comment = false
						if use_ts then
							local row = lnum - 1
							local col = start_col - 1
							local node = vim.treesitter.get_node({
								bufnr = bufnr,
								pos = { row, col },
							})
							while node do
								local nt = node:type()
								if nt:match("comment") or nt:match("Comment") then
									is_comment = true
									break
								end
								node = node:parent()
							end
						end
						if not is_comment then
							seen[word] = true
							table.insert(items, {
								label = word,
								kind = cmp.lsp.CompletionItemKind.Text,
							})
						end
					end
					pos = end_col + 1
				end
			end
			callback({ items = items })
		end

		-- Register the custom source once
		cmp.register_source("buffer-no-comments", buffer_no_comments.new())
		--
		--  END  vibe coded slop

		cmp.setup.filetype({ "markdown", "yacc", "lex", "plaintex", "latex", "tex", "text" }, {
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

		cmp.setup.filetype({ "javascript" }, {
			sources = {
				{
					name = "buffer-no-comments",
				},
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<cr>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.abort(),
			}),
			preselect = false,
		})
	end,
}
