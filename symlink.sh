#!/bin/bash
mv ~/.vimrc ~/.vimrc.backup
mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup

path=$(cd `dirname $0` && pwd) # gets absolute path to the directory this script is contained in

ln -s "$path"/.vimrc ~/.vimrc
ln -s "$path"/init.vim ~/.config/nvim/init.vim

