from subprocess import check_output

def get_tmux_cwd():
    try:
        env_name = check_output("tmux display -p \"TMUXPWD_#D\" | tr -d %",
                    shell=True).strip()
        cmd = "tmux show-environment | grep --color=never \"" + env_name + "\""
        env_val  = check_output(cmd, shell=True).strip()
        return check_output("echo \"" + env_val + "\" | sed 's/^.*=//'",
                                shell=True).strip()
    except:
        return None
