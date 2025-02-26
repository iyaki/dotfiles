#!/usr/bin/env sh

mkdir -p "$HOME/.dotfiles.old"

cp "$HOME/.bash_aliases" "$HOME/.dotfiles.old/"
cp "$HOME/.bash_completion" "$HOME/.dotfiles.old/"
cp "$HOME/.bash_functions" "$HOME/.dotfiles.old/"
cp "$HOME/.bash_profile" "$HOME/.dotfiles.old/"
cp "$HOME/.bashrc" "$HOME/.dotfiles.old/"
cp "$HOME/.gitconfig" "$HOME/.dotfiles.old/"
cp "$HOME/.vimrc" "$HOME/.dotfiles.old/"

ln -s -f "$HOME/.dotfiles/.bash_aliases" $HOME/.bash_aliases
ln -s -f "$HOME/.dotfiles/.bash_completion" $HOME/.bash_completion
ln -s -f "$HOME/.dotfiles/.bash_functions" $HOME/.bash_functions
ln -s -f "$HOME/.dotfiles/.bash_profile" $HOME/.bash_profile
ln -s -f "$HOME/.dotfiles/.bashrc" $HOME/.bashrc
ln -s -f "$HOME/.dotfiles/.gitconfig" $HOME/.gitconfig
ln -s -f "$HOME/.dotfiles/.vimrc" $HOME/.vimrc

if [ "$(id -u)" -eq "0" ]
then
    if type apt-get > /dev/null 2>&1
    then
        apt-get update &&

        apt-get install \
            --assume-yes \
            --no-install-recommends \
            openssh-client \
            less \
            vim

        apt-get clean
        apt-get dsitclean
        apt-get autopurge
    elif type brew > /dev/null 2>&1
    then
        brew install openssh
        brew install vim
        brew install less

        brew cleanup --prune --scrub
    fi
fi
