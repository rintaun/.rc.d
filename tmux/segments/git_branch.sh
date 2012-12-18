# Prints current branch in a VCS directory if it could be detected.

# Source lib to get the function get_tmux_pwd
source "${TMUX_POWERLINE_DIR_HOME}/lib/tmux_adapter.sh"

branch_symbol="⭠"

run_segment() {
	tmux_path=$(get_tmux_cwd)
	cd "$tmux_path"
	branch=""
	if [ -n "${git_branch=$(__parse_git_branch)}" ]; then
		branch="$git_branch"
	fi

	if [ -n "$branch" ]; then
		echo "${branch}"
	fi
	return 0
}


__parse_git_branch() {
  type git >/dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    return
  fi

  local br="$(git branch 2> /dev/null | grep  '^*' | awk '{print $2}' | tr -d '\n')"
  if [ -n "$br" ]
  then
    myupstream="^## (\S+)\.\.\.(\S+)( \[(ahead ([0-9]+))?(, )?(behind ([0-9]+))?\])?$"
    mybranch="^## (\S+)$"
    initial="^## Initial commit on (\S+)$"

    branch=''
    upstream=''
    aheadBy=0
    behindBy=0

    while IFS= read -r line
    do
        if [[ $line =~ $myupstream ]]; then
            # 1 = branch
            # 3 = upstream
            # 4 = ___
            # 5 = ___
            # 6 = ahead
            # 7 = ___
            # 8 = ___
            # 9 = behind
            branch=${BASH_REMATCH[1]}
            aheadBy=$((${BASH_REMATCH[5]} + 0))
            behindBy=$((${BASH_REMATCH[8]} + 0))
        elif [[ $line =~ $mybranch ]]; then
            branch=${BASH_REMATCH[1]}
        elif [[ $line =~ $initial ]]; then
            # 1 = branch
            branch=${BASH_REMATCH[1]}
        fi
    done < <(git -c color.status=false status -s -b 2>/dev/null)

    # clean off unnecessary information
    branch=${branch##*/}

    if [[ $behindBy == 0 && $aheadBy == 0 ]]; then # same as upstream
        branchColor="colour33" #blue
    elif [[ $behindBy == 0 ]]; then # ahead of upstream
        branchColor="colour2" #green
    elif [[ $aheadBy == 0 ]]; then # behind upstream
        branchColor="colour1" #red
    else
        branchColor="colour11" #yellow
    fi

    if [[ -n $branch ]]; then
        printf '%s #[fg=%s]%s' "$branch_symbol" "$branchColor" "$branch"
    fi
  fi
}
