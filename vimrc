runtime macros/matchit.vim
call pathogen#infect()

let mapleader = " "
let g:rspec_command = "Make {spec}"

syntax on
filetype plugin indent on
colorscheme zenburn

autocmd BufNewFile,BufRead *.coffee.erb set filetype=coffee
autocmd BufNewFile,BufRead Guardfile set filetype=ruby
autocmd FileType coffee setl foldmethod=indent foldlevel=9 foldenable
autocmd BufNewFile,BufRead *.rb compiler rspec
autocmd BufNewFile,BufRead *.rb set makeprg=zeus\ rspec

set nocompatible "Turn off vi compatability mode
set backupdir=~/.vim/tmp "Everything vim should be in .vim
set showcmd
set incsearch
set list listchars=tab:»·,trail:· "Show tabs and trailing spaces
set hidden "Allow modified buffers to be hidden/background
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

"map <Leader>t :call RunCurrentSpecFile()<CR>
"map <Leader>s :call RunNearestSpec()<CR>
"map <Leader>l :call RunLastSpec()<CR>
"map <Leader>a :call RunAllSpecs()<CR>

if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 10
endif
