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
    --"preservim/vim-markdown",
    --"tpope/vim-git",
    --"tpope/vim-eunuch",
    --"tpope/vim-dadbod",
    --"luochen1990/rainbow",
    --"Yggdroot/indentLine",
    --"nvim-neorg/neorg",
    --"APZelos/blamer.nvim",
    --"chriskempson/base16-vim",
    --"juneedahamed/vc.vim",
    --"rust-lang/rust.vim",
    --"editorconfig/editorconfig-vim",
    --"kristijanhusak/vim-dadbod-ui",
    --"kristijanhusak/vim-dadbod-completion",
    --"dhruvasagar/vim-zoom",
    --"dhruvasagar/vim-table-mode",
    --{ "junegunn/fzf", build = "./install --all" },
    --{ "junegunn/fzf.vim" },
}
