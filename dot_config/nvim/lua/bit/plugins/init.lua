return {
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
        dependencies = { "rafamadriz/friendly-snippets" },
        event = { "BufReadPre", "BufNewFile" },
        build = "make install_jsregexp"
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
        opts = {
            rocks = { "magick" },
        },
    },
    {
        "3rd/image.nvim",
        dependencies = { "luarocks.nvim" },
        config = true
    },
    {
        "nvim-neorg/neorg",
        dependencies = { "luarocks.nvim" },
        lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
    },
    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        "lucaSartore/fastspell.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
        build = function ()
            vim.system({vim.fn.stdpath("data") .. "/lazy/fastspell.nvim/lua/scripts/install.sh"})
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cmd = "CopilotChatOpen",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {}
    }
}
