#!/usr/bin/env sh

SCRIPTPATH=$(dirname "$(realpath "$0")")

DOTFILES_BACKUP_DIR="$HOME/.dotfiles.old"
mkdir -p "$DOTFILES_BACKUP_DIR"

[ -f "$HOME/.bash_aliases" ] && cp "$HOME/.bash_aliases" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.bash_completion" ] && cp "$HOME/.bash_completion" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.bash_functions" ] && cp "$HOME/.bash_functions" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.bash_profile" ] && cp "$HOME/.bash_profile" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.profile" ] && cp "$HOME/.profile" "$DOTFILES_BACKUP_DIR/"
[ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$DOTFILES_BACKUP_DIR/"

ln -s -f "$SCRIPTPATH/.bash_aliases" $HOME/.bash_aliases
ln -s -f "$SCRIPTPATH/.bash_completion" $HOME/.bash_completion
ln -s -f "$SCRIPTPATH/.bash_functions" $HOME/.bash_functions
ln -s -f "$SCRIPTPATH/.bash_profile" $HOME/.bash_profile
ln -s -f "$SCRIPTPATH/.bashrc" $HOME/.bashrc
ln -s -f "$SCRIPTPATH/.gitconfig" $HOME/.gitconfig
ln -s -f "$SCRIPTPATH/.profile" $HOME/.profile
ln -s -f "$SCRIPTPATH/.vimrc" $HOME/.vimrc

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
