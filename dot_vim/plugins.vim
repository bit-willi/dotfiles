call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'                           " git <3
Plug 'tpope/vim-git'                                " vim Git runtime files
Plug 'airblade/vim-gitgutter'                       " show what lines have changed when inside a git repo
Plug 'haya14busa/incsearch.vim'                     " a better insearch
Plug 'tpope/vim-eunuch'                             " helpers for UNIX
Plug 'easymotion/vim-easymotion'                    " Vim motions on speed
Plug 'luochen1990/rainbow'                          " Rainbow Parentheses Improved
Plug 'neomake/neomake'                              " lint checker
Plug 'Yggdroot/indentLine'                          " Display the indention levels with thin vertical line
Plug 'wakatime/vim-wakatime'                        " Code tracking
Plug 'neovim/nvim-lspconfig'
Plug 'kamailio/vim-kamailio-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'APZelos/blamer.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kylelaker/riscv.vim'
Plug 'scrooloose/nerdcommenter' "commenter <++>
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'chriskempson/base16-vim'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'juneedahamed/vc.vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/svnj.vim'
Plug 'github/copilot.vim'
Plug 'editorconfig/editorconfig-vim'

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
