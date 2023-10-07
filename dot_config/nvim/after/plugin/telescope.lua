require("telescope").setup{
    defaults = {
        file_ignore_patterns = {".git", "node_modules", "vendor"}
    }
}

require("telescope").load_extension("harpoon")

vim.keymap.set("n", "<leader>sf",  require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>sh",  require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>sw",  require("telescope.builtin").grep_string)
vim.keymap.set("n", "<leader>sg",  require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sb",  require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>/",  require("telescope.builtin").current_buffer_fuzzy_find)
