#/usr/bin/env bash
LOCAL_RCD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUPS_DIR="${LOCAL_RCD}/backups"

declare -A files

files=(
    ['tmux/tmux.conf']='.tmux.conf'
    ['tmux/powerlinerc']='.tmux-powerlinerc'
)

__do_backups() {
    echo "Backing up files:"
    for v in "${files[@]}"; do
        file="${HOME}/${v}"
        bakfile="${BACKUPS_DIR}/${v}"
        if [ -f "$file" ]; then
            if (mv "$file" "$bakfile" > /dev/null 2>&1); then
                printf " * Backed up '%s' to '%s'" "$file" "$bakfile"
            else
                printf " x Error: Couldn't backup '%s'" "$file"
            fi
            printf "\n"
        fi
    done
}

__do_links() {
    echo "Linking files:"
    for k in "${!files[@]}"; do
        file="${LOCAL_RCD}/${k}"
        link="${HOME}/${files[$k]}"
        if [ -f "$link" ]; then
            printf " x Error: '%s' already exists" "$link"
        elif (ln -s "$file" "$link" > /dev/null 2>&1); then
            printf " * Linked '%s' to '%s'" "$file" "$link"
        else
            printf " x Error: Couldn't link '%s' to '%s'" "$file" "$link"
        fi
        printf "\n"
    done
}

__do_backups
__do_links
