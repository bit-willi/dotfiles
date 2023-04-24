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
Plug 'pappasam/papercolor-theme-slim'
Plug 'dracula/vim', { 'as': 'dracula' }

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

if stridx(gnome_theme, 'default') != -1
    set background=light
    colorscheme PaperColorSlim
else
    "'default' | 'palenight' | 'ocean' | 'lighter' | 'darker' | 'default-community' | 'palenight-community' | 'ocean-community' | 'lighter-community' | 'darker-community'
    let g:material_theme_style = 'darker'
    let g:material_terminal_italics = 1
    colorscheme material
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

" ================ Extra ===============

" CocConfig:
"{
"    "languageserver": {
"        "ocaml-lsp": {
"            "command": "opam",
"            "args": ["config", "exec", "--", "ocamllsp"],
"            "filetypes": ["ocaml", "reason"]
"        }
"    },
"    "diagnostic.virtualText": true,
"    "diagnostic.virtualTextCurrentLineOnly": false
"}

lua << EOF
require('telescope').setup{
  file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/" }
}
EOF
