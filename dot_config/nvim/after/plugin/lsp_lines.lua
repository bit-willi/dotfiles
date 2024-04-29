require("lsp_lines").setup()

vim.diagnostic.config({ virtual_lines = false })

local  toogle_lsp_lines = function()
    require("lsp_lines").toggle()
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end

vim.keymap.set(
  "n",
  "<Leader>l",
  toogle_lsp_lines,
  { desc = "Toggle lsp_lines" }
)
