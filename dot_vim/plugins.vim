call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'                           " git <3
Plug 'tpope/vim-git'                                " vim Git runtime files
Plug 'airblade/vim-gitgutter'                       " show what lines have changed when inside a git repo
Plug 'luochen1990/rainbow'                          " Rainbow Parentheses Improved
Plug 'Yggdroot/indentLine'                          " Display the indention levels with thin vertical line
Plug 'wakatime/vim-wakatime'                        " Code tracking
Plug 'scrooloose/nerdcommenter'                     " Commenter <++>
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'onsails/lspkind.nvim'
Plug 'kamailio/vim-kamailio-syntax'
Plug 'APZelos/blamer.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'chriskempson/base16-vim'
Plug 'ThePrimeagen/harpoon'
Plug 'juneedahamed/vc.vim'
Plug 'rust-lang/rust.vim'
Plug 'github/copilot.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-scripts/svnj.vim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'nvim-neorg/neorg'
Plug 'dhruvasagar/vim-zoom'
Plug 'tjdevries/express_line.nvim'

"Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
"Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
"Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'
"Plug 'preservim/nerdtree'
"Plug 'vim-vdebug/vdebug'
"Plug 'terroo/vim-auto-markdown'
"Plug 'terryma/vim-multiple-cursors'
"Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
"Plug 'kaicataldo/material.vim', { 'branch': 'main' }
"Plug 'ThePrimeagen/vim-be-good'
"Plug 'folke/which-key.nvim'
"Plug 'folke/neodev.nvim'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'saadparwaiz1/cmp_luasnip'
"Plug 'rafamadriz/friendly-snippets'
"Plug 'j-hui/fidget.nvim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neomake/neomake'                              " lint checker
"Plug 'haya14busa/incsearch.vim'                     " a better insearch
"Plug 'tpope/vim-eunuch'                             " helpers for UNIX
"Plug 'easymotion/vim-easymotion'                    " Vim motions on speed
"Plug 'kylelaker/riscv.vim'
"Plug 'ThePrimeagen/refactoring.nvim'
"Plug 'vim-scripts/svnj.vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" Add plugins to &runtimepath
call plug#end()
