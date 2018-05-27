call plug#begin('~/.config/nvim/plugged')

" Theme
Plug 'jnurmine/Zenburn'

" System
Plug 'tpope/vim-eunuch' " :SudoWrite and other various *nix helpers

" Sensible defaults
Plug 'tpope/vim-sensible' " Set listchars and other options to sensible defaults
Plug 'tpope/vim-sleuth' " Automagically detect and set tabstop

" Ctrl P
Plug 'ctrlpvim/ctrlp.vim' " Finding files and buffers

" General Convenience 
Plug 'tpope/vim-repeat' " Allow plugins to tap into '.'
Plug 'tpope/vim-commentary' " Comment blocks easier
Plug 'tpope/vim-surround' " Change surrounding quotes or tags easier
Plug 'tpope/vim-endwise' " Add 'end' and other structure closures auotmagically
Plug 'tpope/vim-abolish' " :Subvert & :Coersion
Plug 'machakann/vim-highlightedyank' " Highlight the yanked region

" Auto complete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" NerdTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Snippets
Plug 'Shougo/neosnippet.vim' " Snippet enginer
Plug 'Shougo/neosnippet-snippets' " The default snippets
Plug 'honza/vim-snippets' " A vim snippet library

" Git
Plug 'tpope/vim-fugitive' " Git Magic! :Gdiff to resolve merge conflicts in vimdiff
Plug 'airblade/vim-gitgutter' " Show changed/staged git status of lines in a gutter

" --- Syntax Highlights ---
" Git config files
Plug 'tpope/vim-git'

" Markdown - Make conditional on filetype
"tpope/vim-markdown.git

" Ruby - Make conditional on filetype
"tpope/vim-rvm.git
"tpope/vim-bundler.git
"tpope/vim-rails.git
"vim-ruby/vim-ruby.git

call plug#end()

" Settings
let mapleader=" "

let g:deoplete#enable_at_startup = 1

let g:ctrlp_max_files = 20000
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](dist|build|node_modules)$'
  \ }

" Key Mappings
map <Leader>m :NERDTreeFind<CR>
map <Leader>n :NERDTreeToggle<CR>
map <Leader>p :CtrlPBuffer<CR>
