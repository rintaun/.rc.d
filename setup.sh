#/usr/bin/env bash
LOCAL_RCD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUPS_DIR="${LOCAL_RCD}/backups"

files=(
    'bashrc::.bashrc'
    'tmux/tmux.conf::.tmux.conf'
    'vim/vimrc::.vimrc'
    'vim/config::.vim'
)

mv_no_override() {
    local dir file num
    num=0
    if [ -d "$2" ]; then
        dir=$2
        file=$(basename "$1")
    else
        dir=$(dirname "$2")
        file=$(basename "$2")
    fi
    while [ -e "$dir/$file.$num" ]; do
        (( num++ ))
    done
    mv -n "$1" "$dir/$file.$num"
}

__do_submodules() {
    printf "Initializing Git submodules..."
    cd ${LOCAL_RCD}
    if (git submodule update --init --recursive &> /dev/null); then
        printf " completed."
    else
        printf " failed."
    fi
    printf "\n"
}

__do_install_fonts() {
    cd ${LOCAL_RCD}/powerline-fonts
    ./install.sh
}

__do_backups() {
    echo "Backing up files:"
    for index in "${files[@]}"; do
        KEY="${index%%::*}"
        VALUE="${index##*::}"
        file="${HOME}/${VALUE}"
        bakfile="${BACKUPS_DIR}/${VALUE}"
        if [ -e "$file" ]; then
            if (mv_no_override "$file" "$bakfile" &> /dev/null); then
                printf " * Backed up '%s' to '%s'" "$file" "$bakfile"
            else
                printf " x Error: Couldn't backup '%s'" "$file"
            fi
        else
            printf " ? Warning: File '%s' does not exist" "$file"
        fi
        printf "\n"
    done
}

__do_links() {
    echo "Linking files:"
    for index in "${files[@]}"; do
        KEY="${index%%::*}"
        VALUE="${index##*::}"
        file="${LOCAL_RCD}/${KEY}"
        link="${HOME}/${VALUE}"
        if [ ! -d $(dirname $link) ]; then
            mkdir -p $(dirname $link)
        fi

        if [ -f "$link" ]; then
            printf " x Error: '%s' already exists" "$link"
        elif (ln -s "$file" "$link" &> /dev/null); then
            printf " * Linked '%s' to '%s'" "$file" "$link"
        else
            printf " x Error: Couldn't link '%s' to '%s'" "$file" "$link"
        fi
        printf "\n"
    done
}

__do_vim_bundles() {
    printf "Installing vim Bundles... "
    if (vim +BundleInstall +qall &> /dev/null); then
        printf " completed."
    else
        printf " failed."
    fi
    printf "\n"
}

__do_submodules
__do_install_fonts
__do_vim_bundles
__do_backups
__do_links
