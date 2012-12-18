# Prints current branch in a VCS directory if it could be detected.

# Source lib to get the function get_tmux_pwd
source "${TMUX_POWERLINE_DIR_HOME}/lib/tmux_adapter.sh"

run_segment() {
        tmux_path=$(get_tmux_cwd)
        cd "$tmux_path"
        branch=""
        if [ -n "${git_status=$(__parse_git_index_status)}" ]; then
                status="$git_status"
        fi

        if [ -n "$status" ]; then
                echo "${status}"
        fi
        return 0
}

__parse_git_index_status() {
  local br="$(git branch 2> /dev/null | grep  '^*' | awk '{print $2}' | tr -d '\n')"
  if [ -n "$br" ]
  then
    change="^([^#])(.) (.*?)( -> (.*))?$"

    declare -A filesAdded
    declare -A filesModified
    declare -A filesDeleted
    declare -A filesUnmerged

    while IFS= read -r line
    do
        if [[ $line =~ $change ]]; then
            # 1 = index
            # 2 = working
            # 3 = path1
            # 4 = _____
            # 5 = path2
            case ${BASH_REMATCH[2]} in
                "?") filesAdded["${BASH_REMATCH[3]}"]=1;;
                A) filesAdded["${BASH_REMATCH[3]}"]=1;;
                M) filesModified["${BASH_REMATCH[3]}"]=1;;
                D) filesDeleted["${BASH_REMATCH[3]}"]=1;;
                U) filesUnmerged["${BASH_REMATCH[3]}"]=1;;
            esac
        fi
    done < <(git -c color.status=false status -s -b 2>/dev/null)

    fa=${#filesAdded[@]}
    fm=${#filesModified[@]}
    fd=${#filesDeleted[@]}
    fu=${#filesUnmerged[@]}

    [[ $fa > 0 ]] && fa="+$fa" || fa=""
    [[ $fm > 0 ]] && fm="~$fm" || fm=""
    [[ $fd > 0 ]] && fd="-$fd" || fd=""
    [[ $fu > 0 ]] && fu="!$fu" || fu=""

    printf '%s%s%s%s' "$fa" "$fm" "$fd" "$fu"
  fi
}
