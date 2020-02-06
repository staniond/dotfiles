#!/bin/bash
mv ~/.vimrc ~/.vimrc.backup
cp ~/.bashrc ~/.bashrc.backup
mv ~/.gitconfig ~/.gitconfig.backup
mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup

path=$(cd `dirname $0` && pwd) # gets absolute path to the directory this script is contained in

ln -s "$path"/.vimrc ~/.vimrc
ln -s "$path"/.gitconfig ~/.gitconfig
ln -s "$path"/init.vim ~/.config/nvim/init.vim

cat "$path"/custom_bashrc >> ~/.bashrc

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
