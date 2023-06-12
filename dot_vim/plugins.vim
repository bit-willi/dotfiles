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
"Plug 'wakatime/vim-wakatime' " Code tracking
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Plug 'https://gitlab.com/code-stats/code-stats-vim.git'
Plug 'neovim/nvim-lspconfig'

Plug 'kamailio/vim-kamailio-syntax'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'vim-vdebug/vdebug'
Plug 'terroo/vim-auto-markdown'
Plug 'APZelos/blamer.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kylelaker/riscv.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter' "commenter <++>
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'wakatime/vim-wakatime'
Plug 'chriskempson/base16-vim'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/vim-be-good'

"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'pappasam/papercolor-theme-slim'
"Plug 'jwalton512/vim-blade'
"Plug 'itchyny/lightline.vim'
"Plug 'craigemery/vim-autotag'
"Plug 'kebook-programacao-2/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
"Plug 'jvanja/vim-bootstrap3-snippets'
"Plug 'jiangmiao/auto-pairs'

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'deoplete-plugins/deoplete-lsp'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

let g:deoplete#enable_at_startup = 1

" Add plugins to &runtimepath
call plug#end()

" ================ Plugins configuration  ========================

" Auto switch theme based on gnome color scheme
let gnome_theme = system('gsettings get org.gnome.desktop.interface color-scheme')
let base16colorspace=256 " Access colors present in 256 colorspace

if stridx(gnome_theme, 'default') != -1
    set background=light
    colorscheme base16-github
else
    set background=dark
    colorscheme base16-material
end

let g:blamer_enabled = 1 " enable git blame

" Fuzzy configuration
let g:fzf_preview_window = []

let $FZF_DEFAULT_OPTS="--preview-window 'right:60%' --layout reverse --margin=0,0 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

let g:fzf_layout =
\ { 'window':
\ { 'width': 0.98, 'height': 0.7, 'yoffset': 0.94, 'border': 'rounded' }
\ }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Xdebug
let g:vdebug_options= {
\    "port" : 9003,
\    "ide_key" : 'PHPSTORM',
\}

" Coc extensions
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-prettier',
  \ 'coc-pairs',
  \ 'coc-eslint',
  \ 'coc-json',
  \ '@yaegassy/coc-intelephense',
  \ 'coc-clangd',
  \ 'coc-php-cs-fixer',
  \ 'coc-tsserver',
  \ 'coc-sql',
  \ 'coc-java',
  \ 'coc-calc',
  \ 'coc-elixir',
  \ 'coc-pyright',
  "\ 'coc-ltex',
  "\ 'coc-reason',
  "\ 'coc-spell-checker',
  \ ]


" Harpoon
"Mark file
nnoremap <silent> <space>ha :<C-u>lua require("harpoon.mark").add_file()<cr>
"Show file picker
nnoremap <silent> <space>hh :<C-u>lua require("harpoon.ui").toggle_quick_menu()<cr>
"Mark file
nnoremap <silent> <space>hd :<C-u>lua require("harpoon.mark").rm_file()<cr>

" ================ Extra ===============

lua << EOF
require('telescope').setup{
  file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/" }
}
require("telescope").load_extension('harpoon')
EOF

