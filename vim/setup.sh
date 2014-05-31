#!/bin/bash

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -so ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
cd ~/.vim/bundle
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/tpope/vim-afterimage.git
git clone https://github.com/tpope/vim-bundler.git
git clone https://github.com/kchmck/vim-coffee-script.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-endwise.git
git clone https://github.com/tpope/vim-eunuch.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/tpope/vim-git.git
git clone https://github.com/tpope/vim-markdown.git
git clone https://github.com/tpope/vim-rails.git
git clone https://github.com/tpope/vim-repeat.git
git clone https://github.com/tpope/vim-rvm.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/tpope/vim-vividchalk.git
git clone https://github.com/jnurmine/Zenburn.git
git clone https://github.com/thoughtbot/vim-rspec.git
git clone https://github.com/tpope/vim-dispatch.git
git clone https://github.com/vim-ruby/vim-ruby.git
git clone https://github.com/groenewege/vim-less.git
git clone https://github.com/pangloss/vim-javascript.git
