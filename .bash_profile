#!/usr/bin/env bash

# shellcheck source=.profile
[ -f "$HOME/.profile" ] && . "$HOME/.profile"

export PATH=$PATH:/usr/local/go/bin
# export GO111MODULE=on
# export GOPATH=/home/iyaki/go

# less with pretty raw chars, mouse support and without clearing output at exit
export LESS='--no-init --RAW-CONTROL-CHARS --quit-if-one-screen --mouse'

if type bat &>/dev/null
then
    # Use batcat as manpager - https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
    export MANROFFOPT='-c' # https://github.com/sharkdp/bat/issues/3025#issuecomment-2212452233
elif type less &>/dev/null
    export MANPAGER="less -X"
fi

export PERMISSION_DENIED_MESSAGE='Permission denied'

# aws cli configs
export SAM_CLI_TELEMETRY=0

# Brew config to prioritize non-brew package execution
if type brew &>/dev/null
then
    PATH_ORIGINAL="$PATH"
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    export PATH="${PATH_ORIGINAL}:${BREW_PREFIX}/bin:${BREW_PREFIX}/sbin";
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

# Adds global npm packages to path
export PATH="${PATH}:${HOME}/node_modules/.bin"

# Adds nodejs (npm) project packages to path
export PATH="${PATH}:node_modules/.bin"

# Adds php (composer) project packages to path
export PATH="${PATH}:vendor/bin"
