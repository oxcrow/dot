-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Save easily using F2 in normal and insert mode
vim.keymap.set("n", "<F2>", "<esc><cmd>w<cr>", { silent = true })
vim.keymap.set("i", "<F2>", "<esc><cmd>w<cr>", { silent = true })

-- Open files easily using F3 in normal mode using telescope
--
-- NOTE: We can not do it here, because these commands are activated before telescope is loaded,
-- thus this only exists to document what we're doing, and the command needs to be activated witihn
-- telescope plugin's configuration.
--
-- vim.keymap.set("n", "<F3>", require("telescope.builtin").find_files, { desc = "Find Files" })

-- Save all open buffers easily using <S-F2> in normal and insert mode
vim.keymap.set("n", "<F14>", "<esc><cmd>wa<cr>", { silent = true })
vim.keymap.set("i", "<F14>", "<esc><cmd>wa<cr>", { silent = true })

-- Close buffer easily by pressing F12 in normal and insert mode
vim.keymap.set("i", "<F12>", "<esc><cmd>bd<cr>", { silent = true })
vim.keymap.set("n", "<F12>", "<esc><cmd>bd<cr>", { silent = true })

-- Close all buffers by pressing <C-F12> in normal and insert mode
vim.keymap.set("i", "<F36>", "<esc><cmd>qa!<cr>", { silent = true })
vim.keymap.set("n", "<F36>", "<esc><cmd>qa!<cr>", { silent = true })

-- Switch between tabs by pressing F7 and F8
vim.keymap.set("n", "<F7>", "gT", { silent = true })
vim.keymap.set("n", "<F8>", "gt", { silent = true })

-- Switch to command mode by pressing F9
vim.keymap.set("n", "<F9>", "<esc>:", { silent = true })
vim.keymap.set("i", "<F9>", "<esc>:", { silent = true })

-- Scroll down and up using C-j and C-k
vim.keymap.set("n", "<C-j>", "<C-d>", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-u>", { silent = true })

-- Switch to normal mode and save (and autoformat) file
vim.keymap.set("i", "jj", "<esc>:w<cr>", { silent = true })

-- hop.nvim keys to move around in buffers
vim.keymap.set("n", "<leader>l", ":HopLineStart<cr>", { silent = true })
vim.keymap.set("n", "t", ":HopWord<cr>", { silent = true })
vim.keymap.set("v", "t", "<esc>:HopWord<cr>", { silent = true })

-- Use a to append to end of line
vim.keymap.set("n", "a", "<S-a>", { silent = true })

-- Use - to jump to end of line
vim.keymap.set("n", "-", "$", { silent = true })
vim.keymap.set("v", "-", "$", { silent = true })

-- Experimental (Selection-Action model of Helix)
vim.keymap.set("n", "w", "<esc>viw", { silent = true })
vim.keymap.set("v", "w", "<esc>wviw", { silent = true })

-- Use neotree file explorer
vim.keymap.set("n", "<leader>e", ":Neotree<cr>", { silent = true })

-- Open new tab
vim.keymap.set("n", "<leader>t", ":tabnew<cr>", { silent = true })
