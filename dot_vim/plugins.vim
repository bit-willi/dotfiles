call plug#begin('~/.vim/plugged')

Plug 'danielwe/base16-vim'                          " base16 themes
Plug 'tpope/vim-fugitive'                           " git <3
Plug 'tpope/vim-git'                                " vim Git runtime files
Plug 'editorconfig/editorconfig-vim'                " editorConfig plugin for Vim
Plug 'airblade/vim-gitgutter'                       " show what lines have changed when inside a git repo
Plug 'haya14busa/incsearch.vim'                     " a better insearch
Plug 'plasticboy/vim-markdown', {'for': 'markdown'} " Markdown vim mode
Plug 'tpope/vim-eunuch'                             " helpers for UNIX
Plug 'easymotion/vim-easymotion'                    " Vim motions on speed
Plug 'luochen1990/rainbow'                          " Rainbow Parentheses Improved
Plug 'neomake/neomake'                              " lint checker
Plug 'Yggdroot/indentLine'                          " Display the indention levels with thin vertical line
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
Plug 'wakatime/vim-wakatime'                        " Code tracking
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'neovim/nvim-lspconfig'
Plug 'kamailio/vim-kamailio-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-vdebug/vdebug'
Plug 'terroo/vim-auto-markdown'
Plug 'APZelos/blamer.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kylelaker/riscv.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter' "commenter <++>
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'chriskempson/base16-vim'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/vim-be-good'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'juneedahamed/vc.vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/svnj.vim'

"Plug 'williamboman/mason.nvim'
"Plug 'williamboman/mason-lspconfig.nvim'
"Plug 'folke/neodev.nvim'
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'hrsh7th/nvim-cmp'
"Plug 'L3MON4D3/LuaSnip'
"Plug 'saadparwaiz1/cmp_luasnip'
"Plug 'rafamadriz/friendly-snippets'
"Plug 'j-hui/fidget.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Add plugins to &runtimepath
call plug#end()
