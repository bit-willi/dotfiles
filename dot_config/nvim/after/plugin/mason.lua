if not vim.g.vscode then
    require("mason").setup()
    require("mason-lspconfig").setup()
end
