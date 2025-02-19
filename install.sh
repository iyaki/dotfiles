#!/usr/bin/env sh

ln -s -f "$HOME/.dotfiles/.bash_aliases" $HOME/.bash_aliases
ln -s -f "$HOME/.dotfiles/.bash_completion" $HOME/.bash_completion
ln -s -f "$HOME/.dotfiles/.bash_functions" $HOME/.bash_functions
ln -s -f "$HOME/.dotfiles/.bashrc" $HOME/.bashrc
ln -s -f "$HOME/.dotfiles/.gitconfig" $HOME/.gitconfig
ln -s -f "$HOME/.dotfiles/.vimrc" $HOME/.vimrc

if [ "$(id -u)" -eq "0" ]
then
    if type apt-get > /dev/null 2>&1
    then
        apt-get update &&

        apt-get install --assume-yes --no-install-recommends openssh-client vim

        apt-get clean
        apt-get dsitclean
        apt-get autopurge
    elif type brew > /dev/null 2>&1
    then
        brew install openssh
        brew install vim

        brew cleanup --prune --scrub
    fi
fi
