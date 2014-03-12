call pathogen#infect()

set nocompatible
set backupdir=~/.vim/tmp
set showcmd
set incsearch
set list listchars=tab:»·,trail:·

let mapleader = " "
let g:rspec_command = "Make {spec}"

autocmd BufNewFile,BufRead *.coffee.erb set filetype=coffee
autocmd BufNewFile,BufRead Guardfile set filetype=ruby
autocmd FileType coffee setl foldmethod=indent foldlevel=1 foldenable
autocmd BufNewFile,BufRead *.rb compiler rspec
autocmd BufNewFile,BufRead *.rb set makeprg=zeus\ rspec
syntax on
filetype plugin indent on
colorscheme zenburn
set list
set nowrap
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set titlestring=%f
set titlestring+=%=
set titlestring+=%{fugitive#statusline()}
set titlestring+=%{rvm#statusline()}

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 10
endif
