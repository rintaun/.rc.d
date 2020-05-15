#!/usr/bin/env bash
LOCAL_RCD="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
BACKUPS_DIR="${LOCAL_RCD}/backups"

command -v git >/dev/null 2>&1 || \
  { echo >&2 "git is required but not installed. Aborting."; exit 1; }
# command -v node >/dev/null 2>&1 || \
#     { echo >&2 "node is required but not installed. Aborting."; exit 1; }

files=(
    'bash/bashrc::.bashrc'
    'zsh/zshrc::.zshrc'
    'zsh/zlogin::.zlogin'
    'tmux/tmux.conf::.tmux.conf'
    'vim/vimrc::.vimrc'
    'vim/config::.vim'
    'git::.git'
    'nvm/nvmrc::.nvmrc'
    'asdf/asdfrc::.asdfrc'
    'asdf/runtime::.asdf'
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
    cd ${LOCAL_RCD}/awesome-terminal-fonts
    (./install.sh > /dev/null) || return 0
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

        if [ -L "$link" ]; then
          unlink "$link"
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

__do_git_setup() {
    printf "Setting up git... \n"
    # npm install --global git-mob 2>&1 1>/dev/null

    git config --global user.name "Matthew Lanigan"
    git config --global user.email "rintaun@gmail.com"
    git config --global commit.gpgsign true
    git config --global commit.template ~/.git/commit-template
    # git config --global core.hookspath ~/.git/hooks
    printf "\e[1A"
    printf "Setting up git... completed.\n"
}

__do_submodules
__do_install_fonts
__do_vim_bundles
__do_backups
__do_links
__do_git_setup
