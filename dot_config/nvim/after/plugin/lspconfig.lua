local servers = {'phpactor', 'jdtls', 'ts_ls', 'lua_ls', 'sqls', 'pylsp', 'clangd', 'ocamllsp'}

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }

    buf_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Jumps to the definition of the symbol under the cursor" })
    buf_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true, desc = "Information about the symbol under the cursos in a floating window" })
    buf_set_keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true, desc = "Lists all the implementations for the symbol under the cursor in the quickfix window" })
    buf_set_keymap("n", "<leader>rn", ":lua vim.lsp.util.rename()<CR>", { noremap = true, silent = true, desc = "Renaname old_fname to new_fname" })
    buf_set_keymap("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true, desc = "Selects a code action available at the current cursor position" })
    buf_set_keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true, desc = "Lists all the references to the symbl under the cursor in the quickfix window" })
    buf_set_keymap("n", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>",  { noremap = true, silent = true, desc = "Open diagnostic floating window" })
    buf_set_keymap("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>",  { noremap = true, silent = true, desc = "Goto previous diagnostic" })
    buf_set_keymap("n", "]d", ":lua vim.diagnostic.goto_next()<CR>",  { noremap = true, silent = true, desc = "Goto next diagnostic" })
    buf_set_keymap("n", "<leader>lq", ":lua vim.diagnostic.setloclist()<CR>",  { noremap = true, silent = true, desc= "Open list with diagnostic" })
    buf_set_keymap("n", "<leader>lf", ":lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true, desc = "Formats the current buffer" })
end

root_dir = function(fname)
    return vim.fn.getcwd()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local nvim_lsp = require('lspconfig')

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = function(fname)
            return nvim_lsp.util.root_pattern(
            'build.gradle', 'pom.xml', '.git'
            )(fname) or vim.fn.getcwd()
        end,
    })
end

-- Vue lsp cant be on above array...
nvim_lsp['vls'].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
        return nvim_lsp.util.root_pattern(
        'build.gradle', 'pom.xml', '.git'
        )(fname) or vim.fn.getcwd()
    end,
    filetypes = {'vue'},
    cmd = {'vls'}
})
