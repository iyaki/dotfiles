#!/usr/bin/env bash

# Brew config to prioritize non-brew package execution
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]
then
    PATH_ORIGINAL="$PATH"
    BREW_DIR="/home/linuxbrew/.linuxbrew/"
    eval "$(${BREW_DIR}bin/brew shellenv)"
    export PATH="${PATH_ORIGINAL}:${BREW_DIR}/bin:${BREW_DIR}/sbin";
fi

# Start ssh-agent (from https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys)
if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent` > /dev/null
   ssh-add >& /dev/null
fi

# less with pretty raw chars, mouse support and without clearing output at exit
export LESS='--no-init --RAW-CONTROL-CHARS --quit-if-one-screen --mouse'

if type bat &>/dev/null
then
    # Use batcat as manpager - https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
    export MANROFFOPT='-c' # https://github.com/sharkdp/bat/issues/3025#issuecomment-2212452233
elif type less &>/dev/null
then
    export MANPAGER="less -X"
fi

export PERMISSION_DENIED_MESSAGE='Permission denied'

# aws cli configs
export SAM_CLI_TELEMETRY=0

# Adds go to path
export PATH=$PATH:/usr/local/go/bin

# Adds global npm packages to path
export PATH="${PATH}:${HOME}/node_modules/.bin"

# Adds nodejs (npm) project packages to path
export PATH="${PATH}:node_modules/.bin"

# Adds php (composer) project packages to path
export PATH="${PATH}:vendor/bin"

# shellcheck source=.profile
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
