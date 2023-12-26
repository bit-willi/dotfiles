return {
    {
        "tjdevries/express_line.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000 ,
        config = true,
        event = { "BufReadPre", "BufNewFile" },
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
    },
    {
        "ThePrimeagen/harpoon",
        keys = {"<leader>hh", "<leader>hd", "<leader>ha"}
    },
    {
        "scrooloose/nerdcommenter",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "williamboman/mason.nvim",
        cmd = {"Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog"},
    },
    {
        "onsails/lspkind.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    },
    {
        "kamailio/vim-kamailio-syntax",
        ft = "kamailio",
    },
    {
        "wakatime/vim-wakatime",
        event = "InsertEnter",
    },
    {
        "github/copilot.vim",
        event = "InsertEnter",
    },
    {
        "christoomey/vim-tmux-navigator",
        event= "VeryLazy"
    },
    {
        "folke/todo-comments.nvim",
        event= "VeryLazy"
    },
    {
        "tpope/vim-fugitive",
        cmd = "Git",
    },
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter"
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope"
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter"
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter"
    },
    {
        "vim-scripts/svnj.vim",
        event = "VeryLazy"
    },
    {
        "tpope/vim-dispatch",
        event = "VeryLazy"
    },
    {
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeEnable"
    }
}
