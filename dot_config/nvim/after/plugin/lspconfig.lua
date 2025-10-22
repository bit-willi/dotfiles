local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", vim.tbl_extend('keep', opts, { desc = "Jumps to the definition" }))
  buf_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", vim.tbl_extend('keep', opts, { desc = "Hover information" }))
  buf_set_keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", vim.tbl_extend('keep', opts, { desc = "List implementations" }))
  buf_set_keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", vim.tbl_extend('keep', opts, { desc = "Rename symbol" }))
  buf_set_keymap("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", vim.tbl_extend('keep', opts, { desc = "Code action" }))
  buf_set_keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>", vim.tbl_extend('keep', opts, { desc = "List references" }))
  buf_set_keymap("n", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>", vim.tbl_extend('keep', opts, { desc = "Open diagnostic float" }))
  buf_set_keymap("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", vim.tbl_extend('keep', opts, { desc = "Goto previous diagnostic" }))
  buf_set_keymap("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", vim.tbl_extend('keep', opts, { desc = "Goto next diagnostic" }))
  buf_set_keymap("n", "<leader>lq", ":lua vim.diagnostic.setloclist()<CR>", vim.tbl_extend('keep', opts, { desc = "Open diagnostics list" }))
  buf_set_keymap("n", "<leader>lf", ":lua vim.lsp.buf.format()<CR>", vim.tbl_extend('keep', opts, { desc = "Format buffer" }))
end

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = on_attach,
})

vim.lsp.config('phpactor', {})

vim.lsp.config('vls', {
  root_dir = function(fname)
    return vim.lsp.util.root_pattern(
      'build.gradle', 'pom.xml', '.git'
    )(fname) or vim.fn.getcwd()
  end,
  filetypes = { 'vue' },
  cmd = { 'vls' }
})
