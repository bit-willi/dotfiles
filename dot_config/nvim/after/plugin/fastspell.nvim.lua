local fastspell = require("fastspell")

fastspell.setup({})

vim.api.nvim_set_keymap("n", "<leader>sc", "", {
    noremap = true,
    silent = true,
    desc = "[S]pell [C]heck",
    callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        local first_line = 0
        local last_line =vim.api.nvim_buf_line_count(buffer)
        fastspell.sendSpellCheckRequest(first_line, last_line)
    end,
})

vim.api.nvim_set_keymap("n", "<leader>si", "", {
    noremap = true,
    silent = true,
    desc = "[S]pell [I]gnore",
    callback = function()
        fastspell.sendSpellCheckRequest(0,0)
    end,
})
