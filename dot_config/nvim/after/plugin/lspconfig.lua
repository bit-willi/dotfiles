local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    buf_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Jumps to the definition of the symbol under the cursor" })
    buf_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true, desc = "Information about the symbol under the cursor in a floating window" })
    buf_set_keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true, desc = "Lists all implementations for the symbol under the cursor in the quickfix window" })
    buf_set_keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true, desc = "Rename symbol under cursor" })
    buf_set_keymap("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true, desc = "Select a code action" })
    buf_set_keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true, desc = "List references to symbol under cursor" })
    buf_set_keymap("n", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true, desc = "Open diagnostic floating window" })
    buf_set_keymap("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true, desc = "Goto previous diagnostic" })
    buf_set_keymap("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true, desc = "Goto next diagnostic" })
    buf_set_keymap("n", "<leader>lq", ":lua vim.diagnostic.setloclist()<CR>", { noremap = true, silent = true, desc = "Open list with diagnostics" })
    buf_set_keymap("n", "<leader>lf", ":lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true, desc = "Format current buffer" })
end

vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    on_attach = on_attach,
})

local servers = {'phpactor'}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach
    })
end
