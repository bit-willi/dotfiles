return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "godlygeek/tabular",
        cmd = "Tabularize"
    },
    {
        "nvim-lua/plenary.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "airblade/vim-gitgutter",
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "scrooloose/nerdcommenter",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog" },
        enabled = not vim.g.vscode,
    },
    {
        "onsails/lspkind.nvim",
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
        enabled = not vim.g.vscode,
    },
    {
        "kamailio/vim-kamailio-syntax",
        ft = "kamailio",
    },
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
        enabled = not vim.g.vscode,
    },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        enabled = not vim.g.vscode,
    },
    {
        "tpope/vim-fugitive",
        cmd = "Git",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        event = { "BufReadPre", "BufNewFile" },
        build = "make install_jsregexp",
        enabled = not vim.g.vscode,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope"
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        enabled = not vim.g.vscode,
    },
    {
        "tpope/vim-dispatch",
        event = "VeryLazy",
    },
    {
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeEnable",
    },
    {
        "APZelos/blamer.nvim",
        cmd = "BlamerToggle",
        enabled = not vim.g.vscode,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        enabled = not vim.g.vscode,
    },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
        enabled = not vim.g.vscode,
    },
    {
        "3rd/image.nvim",
        dependencies = { "luarocks.nvim" },
        config = true,
        enabled = not vim.g.vscode,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "lucaSartore/fastspell.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
        build = function()
            vim.system({ vim.fn.stdpath("data") .. "/lazy/fastspell.nvim/lua/scripts/install.sh" })
        end
    },
    {
        "tpope/vim-sleuth",
        event = "VeryLazy"
    }
}
