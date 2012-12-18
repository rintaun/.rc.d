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

    declare -A indexAdded
    declare -A indexModified
    declare -A indexDeleted
    declare -A indexUnmerged

    while IFS= read -r line
    do
        if [[ $line =~ $change ]]; then
            # 1 = index
            # 2 = working
            # 3 = path1
            # 4 = _____
            # 5 = path2
            case ${BASH_REMATCH[1]} in
                A) indexAdded["${BASH_REMATCH[3]}"]=1;;
                M) indexModified["${BASH_REMATCH[3]}"]=1;;
                R) indexModified["${BASH_REMATCH[3]}"]=1;;
                C) indexModified["${BASH_REMATCH[3]}"]=1;;
                D) indexDeleted["${BASH_REMATCH[3]}"]=1;;
                U) indexUnmerged["${BASH_REMATCH[3]}"]=1;;
            esac
        fi
    done < <(git -c color.status=false status -s -b 2>/dev/null)

    ia=${#indexAdded[@]}
    im=${#indexModified[@]}
    id=${#indexDeleted[@]}
    iu=${#indexUnmerged[@]}

    [[ $ia > 0 ]] && ia="+$ia" || ia=""
    [[ $im > 0 ]] && im="~$im" || im=""
    [[ $id > 0 ]] && id="-$id" || id=""
    [[ $iu > 0 ]] && iu="!$iu" || iu=""

    printf '%s%s%s%s' "$ia" "$im" "$id" "$iu"
  fi
}
