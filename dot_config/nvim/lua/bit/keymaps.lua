-- Helpers to make life happy
vim.keymap.set("n", "<leader>fs", vim.cmd.Ex)
vim.keymap.set("n", "<Esc><Esc>", ":noh<cr> :call clearmatches()<cr>" )

-- Easy tabs
vim.keymap.set("n", "<leader>tt", ":tabnew<cr>")
vim.keymap.set("n", "<leader>tn", ":tabnext<cr>")
vim.keymap.set("n", "<leader>tp", ":tabprevious<cr>")

-- Easy splits
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>")

-- Delete without yank
vim.keymap.set("v", "D", "\"_dd<Esc>")

-- Center line after jump
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")