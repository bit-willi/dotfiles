local actions = require("telescope.actions")
local action_layout = require "telescope.actions.layout"

require("telescope").setup{
    defaults = {
        file_ignore_patterns = {".git", "node_modules", "vendor"},
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ['<C-d>'] = actions.delete_buffer,
            ['<esc>'] = actions.close,
            ["<M-p>"] = action_layout.toggle_preview,
            ["<M-m>"] = action_layout.toggle_mirror,
          },
        },
        preview = {
            treesitter = false
        },
        path_display = {
            filename_first = {
                reverse_directories = false
            }
        }
    }
}

vim.keymap.set("n", "<leader>sf",  require("telescope.builtin").find_files, { desc = "Search files in cwd" })
vim.keymap.set("n", "<leader>sh",  require("telescope.builtin").help_tags, { desc = "Search help tags in cwd" })
vim.keymap.set("n", "<leader>sw",  require("telescope.builtin").grep_string, { desc = "Search string in cwd" })
vim.keymap.set("n", "<leader>sg",  require("telescope.builtin").live_grep, { desc = "Grep files in cwd" })
vim.keymap.set("n", "<leader>sb",  require("telescope.builtin").buffers, { desc = "Search buffers in cwd" })
vim.keymap.set("n", "<leader>/",  require("telescope.builtin").current_buffer_fuzzy_find, { desc = "Search strings in current buffer" })
