#!/usr/bin/env bash

# Es importante que .bash_completion se cargue antes que .bash_aliases

# Easier navigation
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Files manipulation
alias mv='mv -v'
alias rm='rm -I -v'
alias cp='cp -v'

# clear - shortcut: Ctrl + l
alias cl='clear'

# ls
if type lsd &>/dev/null
then
    alias l='lsd --long '
    alias ll='lsd --long --almost-all '
else
    alias l='ls -l --human-readable '
    alias ll='ls -l --almost-all --human-readable '
fi

# bat - https://github.com/sharkdp/bat
alias bat='bat --italic-text always --pager "less -rX" '
# alias bat-plain='bat --pager "less -rX" --plain'
alias bap='bat --plain'

# git
alias g='git '
type __git_complete &> /dev/null && __git_complete g __git_main

# git legacy aliases (los alias de git se migraron al sistema de alias propio de git)
alias ga='git add '
type __git_complete &> /dev/null && __git_complete gco _git_add
alias gb='git branch '
type __git_complete &> /dev/null && __git_complete gco _git_branch
alias gc='git commit -m '
alias gca='git commit --amend --no-edit'
alias gco='git checkout '
type __git_complete &> /dev/null && __git_complete gco _git_checkout
alias gd='git diff '
type __git_complete &> /dev/null && __git_complete gco _git_diff
alias gdd='git difftool '
type __git_complete &> /dev/null && __git_complete gco _git_difftool
alias gl='git log --show-signature | bat --pager "less -rX" --plain'
alias glo='git log --color --pretty=format:"%Cred%H%Creset - %C(blue)(%G? %GT)%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" | bat --pager "less -rX" --plain'
alias glol='git log --color --graph --pretty=format:"%Cred%h%Creset - %C(blue)(%G? %GT)%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit -- | bat --pager "less -rX" --plain'
alias gp='git push '
type __git_complete &> /dev/null && __git_complete gco _git_push
alias gpsu='git push --set-upstream '
type __git_complete &> /dev/null && __git_complete gco _git_push
alias gpr='git pr'
complete -F __remote_branch_completion gpr
alias gr='git reset'
type __git_complete &> /dev/null && __git_complete gco _git_reset
alias gs='git status '
type __git_complete &> /dev/null && __git_complete gco _git_status
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'

# vi access shortcuts
alias vihosts="sudo vi /etc/hosts"
alias vissh="vi ~/.ssh/config"
alias viovpn="vi ~/OpenVPN/Alephoo/iyaki.desa.ovpn"

# ag silver searcher
alias ag='ag -f -S --hidden '

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# shorthands for user defined functions
alias oossh='alephoossh'
alias oossm='alephoossm'
alias ootunnelssm='alephootunnelssm'
alias oomysql='alephoomysql'
complete -F __oomysql_completion oomysql
alias ooec2='alephooec2'

# devcontainer
alias devcontainer-up="devcontainer up --workspace-folder . "

# manage environment versioning
alias config='git --git-dir=$HOME/.git/ --work-tree=$HOME'
