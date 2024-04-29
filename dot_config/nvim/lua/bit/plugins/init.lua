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
        "hrsh7th/nvim-cmp",
        event = "InsertEnter"
    },
    {
        "tpope/vim-dispatch",
        event = "VeryLazy"
    },
    {
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeEnable"
    },
    {
        "APZelos/blamer.nvim",
        cmd = "BlamerToggle"
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end
    },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle" }
    },
    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
    },
    {
        "nvim-neorg/neorg",
        dependencies = { "luarocks.nvim" },
        lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        config = true,
    },
    {
        "luckasRanarison/nvim-devdocs",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {}
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        keys = {"<leader>l"}
    }
}
