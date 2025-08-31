#!/usr/bin/env bash

# Es importante que .bash_completion se cargue antes que .bash_functions

# -------------------------------------------------- utils --------------------------------------------------

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@" || return 1
}

# ignores "permission denied" outputs
function ignore_permision_denied() {
    grep -v "$PERMISSION_DENIED_MESSAGE"
}

capitalize () {
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}

toLowerCase () {
    echo "$(tr '[:upper:]' '[:lower:]' <<< ${1})"
}

# find shorthand
function f() {
    find . -name "${1}" 2>&1 | ignore_permision_denied
}

function csvpreview() {
    sed 's/,,/, ,/g;s/,,/, ,/g' "$@" | column -s, -t | less -#2 -N -S
}

# du -sh (Disk Usage Summarizing and Human readable)
#
# Arguemnts:
# 1. Extra arguments (flags and path). If none is provided path * is used
function dush() {
    if [ -z "${1}" ]
    then
        du -sh ./* 2>&1 | ignore_permision_denied
    else
        du -sh "$@" 2>&1 | ignore_permision_denied
    fi
}

# dush | sort -hr | head -n<listed-rows> (Disk Usage Summarizing and Human
# readable), sorted reverse by human readable size and filter first <listed-rows>
#
# Arguemnts:
# 1. Number of rows to list. Default: 10
function dush-sort() {
    if [ -z "${1}" ]
    then
        dush "" | sort -hr | head -n10
    else
        dush "" | sort -hr | head -n"${1}"
    fi
}

function ppk2pem() {
    local PPK_FILE_NAME="${1:-}"

    local KEY_NAME
    KEY_NAME="$(echo "${PPK_FILE_NAME}" | cut -f 1 -d '.')"

    puttygen "${PPK_FILE_NAME}" -O private-openssh -o "${KEY_NAME}.pem"
}

function attach-docker() {
    docker exec -it "${1}" "${2:-bash}"
}
# attach-docker bash completion
complete -F __attach-docker_completion attach-docker

# This function creates a ssh tunnel to a specified host
#
# Arguments:
# 1. What to do with the tunnel. Possible values: open|close
# 2. Connection alias from the ssh config
# 3. Local port (only used to open tunnels)
# 4. Destination (only used to open tunnels)
# 5. Remote port (only used to open tunnels)
function ssh-tunnel() {
    case "${1:-}" in

    "open")
        ssh -Nf -M -S "/tmp/${2}" "${2}" -L "${3}:${4}:${5}"
        ;;

    "close")
        ssh -S "/tmp/${2}" -O exit "${2}"
        ;;

    *)
        echo 'Invalid first argument. It must be "open" or "close"'
        ;;
    esac
}

# Redimensiona un video a un ancho especificado, manteniendo su relacion de aspecto
# Arguemntos:
#   1. Path al video
#   2. Ancho (en pixeles)
#   3. Path al directorio donde se guardara el video (opcional, si no se especifica se guardara en el mismo directorio)
function video-resize() {
    if [ -z "${1}" ]
    then
        echo "Debe pasar el path a un video como primer argumento"
        return 1
    fi

    if [ -z "${2}" ]
    then
        echo "Debe pasar el ancho (en pixeles) al que redimensionar el video como segundo argumento"
        return 1
    fi

    local VIDEO="${1}"
    local SIZE="${2}"
    local DESTINATION_DIR=${3:-"$(dirname "${VIDEO}")"}
    local BASENAME
    BASENAME="$(basename -- "${VIDEO}")"
    local EXTENSION="${BASENAME##*.}"
    local FILENAME="${BASENAME%.*}"

    ffmpeg -i "${VIDEO}" -vf "scale=${SIZE}:-2" "${DESTINATION_DIR}${FILENAME}-${SIZE}.${EXTENSION}"
}

# Convierte un video a formato AVIF
# Arguemntos:
#   1. Path al video
#   2. Path al directorio donde se guardara el video (opcional, si no se especifica se guardara en el mismo directorio)
function video-to-avif() {
    if [ -z "${1}" ]
    then
        echo "Debe pasar el path a un video como primer argumento"
        return 1
    fi

    local VIDEO="${1}"
    local DESTINATION_DIR=${2:-"$(dirname "${VIDEO}")"}
    local BASENAME="$(basename -- "${VIDEO}")"
    local FILENAME="${BASENAME%.*}"

    local TEMPORAL_Y4M="/tmp/${FILENAME}.y4m"

    ffmpeg -i "${1}" -pix_fmt yuv420p -f yuv4mpegpipe "${TEMPORAL_Y4M}"
    avifenc "${TEMPORAL_Y4M}" "${DESTINATION_DIR}${FILENAME}.avif"
    rm -f "${TEMPORAL_Y4M}"
}

# Extrae el primer frame de un video
# Arguemntos:
#   1. Path al video
#   2. Path al directorio donde se guardara el video (opcional, si no se especifica se guardara en el mismo directorio)
function video-first-frame() {
    if [ -z "${1}" ]
    then
        echo "Debe pasar el path a un video como primer argumento"
        return 1
    fi

    local VIDEO="${1}"
    local DESTINATION_DIR=${2:-"$(dirname "${VIDEO}")"}
    local BASENAME="$(basename -- "${VIDEO}")"
    local FILENAME="${BASENAME%.*}"

    ffmpeg -i "${1}" -vf "scale=iw*sar:ih,setsar=1" -vframes 1 "${DESTINATION_DIR}${FILENAME}.png"
}

function video-last-frame() {
    if [ -z "${1}" ]
    then
        echo "Debe pasar el path a un video como primer argumento"
        return 1
    fi

    local VIDEO="${1}"
    local DESTINATION_DIR=${2:-"$(dirname "${VIDEO}")"}
    local BASENAME="$(basename -- "${VIDEO}")"
    local FILENAME="${BASENAME%.*}"

    ffmpeg -sseof -3 -i "${1}" -update 1 -q:v 1 "${DESTINATION_DIR}${FILENAME}.jpg"
}

# -------------------------------------------------- git functions --------------------------------------------------

function get_repository_path() {
    git rev-parse --show-toplevel
}

if ! type gcr &>/dev/null
then
    # git checkout remote
    # For usage execute `gcr` without any argument
    function gcr() {
        local REMOTE='origin'

        if [ -z "${1}" ]
        then
            echo "gcr creates a new branch based on an ${REMOTE} branch.
    If the branch already exists it is reseted.

    Usage:
        gcr <${REMOTE} base branch> <name-for-new-branch>
    Example:
            gcr development new-feature
        will result in the creation of the branch development_new-feature
        tracking ${REMOTE}/development
    "
            return
        fi

        git fetch -t -P "${REMOTE}" &&

        local BRANCH_NAME='' &&

        if [ -z "$2" ]
        then
            BRANCH_NAME="${1}"
        else
            BRANCH_NAME="${1}_${2}"
        fi &&

        git checkout -t "${REMOTE}/${1}" -B "${BRANCH_NAME}" &&

        project_deploy
    }
fi
# gcr bash completion
complete -F __remote_branch_completion gcr

# git checkout pull request (gcpr) creates a new branch named
# "pr-<pull request id>" based on an github pull request and changes the branch.
#
# Usage: gcpr <pull request id>
function gcpr() {
    local REMOTE='origin'

    git fetch -f "${REMOTE}" "pull/${1}/head:pr-${1}" && git checkout "pr-${1}" &&

    project_deploy
}

if ! type gwr &>/dev/null
then
    # git worktree remote
    # For usage execute `gwr` without any argument
    function gwr() {
        local REMOTE='origin'

        if [ -z "${1}" ]
        then
            echo "gwr creates a new worktree based on an ${REMOTE} branch.
    If the worktree already exists it is reseted.

    Usage:
        gwr <${REMOTE} base branch> <name-for-new-branch>
    Example:
            gwr development new-feature
        will result in the creation of the worktree development_new-feature (inside ${WORKTREE_DIR}/development_new-feature)
        tracking ${REMOTE}/development
    "
            return
        fi

        local WORKTREE_DIR
        WORKTREE_DIR="../$(basename "$(pwd -P)")-worktrees"
        local WORKTREE_DIR_FULL
        WORKTREE_DIR_FULL="$(get_repository_path)/${WORKTREE_DIR}"

        mkdir -p "${WORKTREE_DIR_FULL}"

        git fetch -t -P "${REMOTE}" &&

        local BRANCH_NAME='' &&

        if [ -z "$2" ]
        then
            BRANCH_NAME="${1}"
        else
            BRANCH_NAME="${1}_${2}"
        fi &&

        git worktree add --track -B "${BRANCH_NAME}" "${WORKTREE_DIR_FULL}/${BRANCH_NAME}" "${REMOTE}/${1}" &&

        if [ "$VSCODE_SHELL_INTEGRATION" = '1' ]
        then
            code --add "${WORKTREE_DIR_FULL}/${BRANCH_NAME}"
        fi

        cd "${WORKTREE_DIR_FULL}/${BRANCH_NAME}" || return 1 &&

        project_deploy
    }
fi
# gwr bash completion
complete -F __remote_branch_completion gwr

if ! type gw &>/dev/null
then
    # git worktree add
    # For usage execute `gw` without any argument
    function gw() {
        if [ -z "${1}" ]
        then
            echo "gw creates a new worktree based on an ${REMOTE} branch.
    If the worktree already exists it is reseted.

    Usage:
        gw <${REMOTE} base branch> <name-for-new-branch>
    Example:
            gw development new-feature
        will result in the creation of the worktree development_new-feature (inside ${WORKTREE_DIR}/development_new-feature)
        tracking ${REMOTE}/development
    "
            return
        fi

        local WORKTREE_DIR
        WORKTREE_DIR="../$(basename "$(pwd -P)")-worktrees"
        local WORKTREE_DIR_FULL
        WORKTREE_DIR_FULL="$(get_repository_path)/${WORKTREE_DIR}"

        mkdir -p "${WORKTREE_DIR_FULL}"

        git worktree add -B "${1}" "${WORKTREE_DIR_FULL}/${1}" &&

        if [ "$VSCODE_SHELL_INTEGRATION" = '1' ]
        then
            code --add "${WORKTREE_DIR_FULL}/${1}"
        fi

        cd "${WORKTREE_DIR_FULL}/${1}" || return 1 &&

        project_deploy
    }
fi
# gw bash completion
complete -F __remote_branch_completion gw

function fire() {
    git add . &&
    git commit -m "${1:-';)'}" &&
    git push
}

# -------------------------------------------------- dev functions --------------------------------------------------

function php_deploy() {
    if [ -f "$( get_repository_path )/composer.json" ]
    then
        composer install
    fi
}

function node_deploy() {
    if [ -f "$( get_repository_path )/package.json" ]
    then
        npm install --save-exact
    fi
}

function project_deploy() {
    php_deploy
    node_deploy
}

function swagger-editor() {
    local PORT="${1:-8081}"
    docker run -p "${PORT}:8080" swaggerapi/swagger-editor
}

function swagger-ui() {
    local PORT="${1:-8081}"
    docker run -p "$PORT:8080" swaggerapi/swagger-ui
}

# -------------------------------------------------- additional project specific functions --------------------------------------------------W

[ -f "$HOME/.bash_functions-alephoo" ] && . "$HOME/.bash_functions-alephoo"

[ -f "$HOME/.bash_functions-simplenewsletter" ] && . "$HOME/.bash_functions-simplenewsletter"
