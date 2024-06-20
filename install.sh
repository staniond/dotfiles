#!/bin/bash
path=$(cd `dirname $0` && pwd) # gets absolute path to the directory this script is contained in

backup_and_link() {
    if [ -f "$1" ]
    then
        echo Backing up "$1" to "$1".backup
        mv "$1" "$1".backup
    fi
    echo Linking "$1" to  "$path"/"$2"
    ln -s "$path"/"$2" "$1"
}

backup_and_link ~/.vimrc .vimrc
echo
mkdir -p ~/.config/nvim
backup_and_link ~/.config/nvim/init.vim init.vim
echo
backup_and_link ~/.gitconfig .gitconfig
echo
backup_and_link ~/.tmuxline .tmuxline
echo
backup_and_link ~/.tmux.conf .tmux.conf
echo

if cat ~/.bashrc | fgrep -q DOTFILES_TAG;
then
    echo '~/.bashrc already sources custom_bashrc contents'
else
    echo 'custom_bashrc not yet in ~/.bashrc, backing up to ~/.bashrc.backup'
    cp ~/.bashrc ~/.bashrc.backup
    echo adding source "$path"/custom_bashrc to '~/.bashrc'
    echo '# DOTFILES_TAG' >> ~/.bashrc
    echo source "$path"/custom_bashrc >> ~/.bashrc
fi

echo

if [ -f ~/.local/share/nvim/site/autoload/plug.vim ]
then
    echo 'vimplug already installed'
else
    echo 'installing vimplug'
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo


echo 'Installing starship'
curl -sS https://starship.rs/install.sh | sh
starship preset gruvbox-rainbow -o ~/.config/starship.toml

echo 'Installing jedi'
pip3 install jedi
