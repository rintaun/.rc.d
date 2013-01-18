# -*- coding: utf-8 -*-
from utilities import get_tmux_cwd
from os import chdir
from subprocess import check_output
import sys
import re

def __git_status():
    tmux_cwd = get_tmux_cwd()
    if tmux_cwd == None:
        return None
    chdir(tmux_cwd)
    try:
        check_output("type git >/dev/null 2>&1", shell=True)
    except:
        return None

    try:
        check_output("git branch 2> /dev/null | grep '^*' | awk " +
                "'{print $2}' | tr -d '\n'", shell=True)
    except:
        return None

    try:
        output = check_output("git -c color.status=false status -s -b " +
                "2>/dev/null", shell=True).strip()
    except:
        return None

    return output


def git_branch():
    output = __git_status()
    if output is None:
        return None

    myupstream = r"^## (\S+)\.\.\.(\S+)( \[(ahead ([0-9]+))?(, )?(behind ([0-9]+))?\])?$"
    mybranch = r"^## (\S+)$"
    initial = r"^## Initial commit on (\S+)$"

    branch = ''
    upstream = ''
    aheadBy = 0
    behindBy = 0

    for line in output.splitlines(True):
        m = re.search(myupstream, line)
        if m:
            branch = m.group(1)
            aheadBy = m.group(5)
            behindBy = m.group(8)
        else:
            m = re.search(mybranch, line)
            if m:
                branch = m.group(1)
            else:
                m = re.search(initial, line)
                if m:
                    branch = m.group(1)

    branch = branch.strip()
    if branch.__len__() > 0:
        if behindBy == 0 and aheadBy == 0:
            branch_color = "colour33" # blue
        elif behindBy == 0:
            branch_color = "colour2"  # green
        elif aheadBy == 0:
            branch_color = "colour1"  # red
        else:
            branch_color = "colour11" # yellow

        branch = "#[fg={0}]{1}#[fg=colour250]".format(branch_color, branch)
        # '%s #[fg=%s]%s' "$branch_symbol" "$branchColor" "$branch"
    return branch

def git_index_status():
    output = __git_status()
    if output is None:
        return None

    change = r"^([^#])(.) (.*?)( -> (.*))?$"

    added = {}
    modified = {}
    deleted = {}
    unmerged = {}

    for line in output.splitlines(True):
        m = re.search(change, line)
        if m:
            modifier = m.group(1)
            filename = m.group(3)
            if modifier is "A":
                # indexAdded["${BASH_REMATCH[3]}"]=1;;
                added[filename] = 1
            elif modifier is "M":
                # indexModified["${BASH_REMATCH[3]}"]=1;;
                modified[filename] = 1
            elif modifier is "R":
                # indexModified["${BASH_REMATCH[3]}"]=1;;
                modified[filename] = 1
            elif modifier is "C":
                # indexModified["${BASH_REMATCH[3]}"]=1;;
                modified[filename] = 1
            elif modifier is "D":
                # indexDeleted["${BASH_REMATCH[3]}"]=1;;
                deleted[filename] = 1
            elif modifier is "U":
                # indexUnmerged["${BASH_REMATCH[3]}"]=1;;
                unmerged[filename] = 1
            
    iA = "+{0}".format(len(added))    if len(added)    > 0 else ""
    iM = "~{0}".format(len(modified)) if len(modified) > 0 else ""
    iD = "-{0}".format(len(deleted))  if len(deleted)  > 0 else ""
    iU = "!{0}".format(len(unmerged)) if len(unmerged) > 0 else ""

    output = "{0}{1}{2}{3}".format(iA, iM, iD, iU)

    if output is "":
        return None
    
    return "{0}#[fg=colour250]".format(output)

def git_local_status():
    output = __git_status()
    if output is None:
        return None

    change = r"^([^#])(.) (.*?)( -> (.*))?$"

    added = {}
    modified = {}
    deleted = {}
    unmerged = {}

    for line in output.splitlines(True):
        m = re.search(change, line)
        if m:
            modifier = m.group(2)
            filename = m.group(3)
            if modifier is "A":
                # indexAdded["${BASH_REMATCH[3]}"]=1;;
                added[filename] = 1
            elif modifier is "M":
                # indexModified["${BASH_REMATCH[3]}"]=1;;
                modified[filename] = 1
            elif modifier is "R":
                # indexModified["${BASH_REMATCH[3]}"]=1;;
                modified[filename] = 1
            elif modifier is "C":
                # indexModified["${BASH_REMATCH[3]}"]=1;;
                modified[filename] = 1
            elif modifier is "D":
                # indexDeleted["${BASH_REMATCH[3]}"]=1;;
                deleted[filename] = 1
            elif modifier is "U":
                # indexUnmerged["${BASH_REMATCH[3]}"]=1;;
                unmerged[filename] = 1
            
    iA = "+{0}".format(len(added))    if len(added)    > 0 else ""
    iM = "~{0}".format(len(modified)) if len(modified) > 0 else ""
    iD = "-{0}".format(len(deleted))  if len(deleted)  > 0 else ""
    iU = "!{0}".format(len(unmerged)) if len(unmerged) > 0 else ""

    output = "{0}{1}{2}{3}".format(iA, iM, iD, iU)

    if output is "":
        return None

    return "{0}#[fg=colour250]".format(output)
