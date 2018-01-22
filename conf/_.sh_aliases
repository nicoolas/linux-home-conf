
alias slogs='sudo tail -n 40 -F /var/log/syslog'
alias grep='grep --color=auto'

alias dpkg_disk_usage="dpkg-query -Wf '\${Installed-Size}\t\${Package}\t\${Priority}\n\' | egrep '\s(optional|extra)' | cut -f 1,2 | sort -nr"

# startup of the ssh-agent
function f_start_ssh_agent() {
  local prefix="SSh-Agent: "

  if which pgrep >/dev/null 2>&1
  then
    AGENT_PID=$(pgrep -x ssh-agent)
    if [ $? -ne 0 ]
    then
      echo "$prefix: Starting SSH Agent"

      eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa
      setx SSH_AUTH_SOCK $SSH_AUTH_SOCK
      setx SSH_AGENT_PID $SSH_AGENT_PID

      echo "$prefix: SSH Agent running (PID: $SSH_AGENT_PID)"
    else
      echo "$prefix: SSH Agent already running (PID: $AGENT_PID)"
    fi
  else
	# Cygwin: package procps
    echo "$prefix: SSH Agent: Missing 'pgrep'"
  fi
}

# TMUX
alias tmux-ls='tmux list-sessions'
alias tmux-copy=" tee /tmp/screen-exchange"
alias tmux-copy-n=' awk "//{printf \$1 }" | tee /tmp/screen-exchange'

function browse()
{
    local _dir="$1"
    for _b in "caja" "nautilus" "dolphin" "nemo"
    do
        if which $_b &> /dev/null
        then
            [ -z "$_dir" ] && _dir="$(pwd)"
            echo $_b "$_dir"
            $_b "$_dir"  &>/dev/null &
            return 0
        fi
    done

    if which explorer.exe 2>/dev/null | grep -q '^/cygdrive/'
    then
        explorer.exe /e /root,$(pwd | sed 's_^/cygdrive/__;s_/_:\\_;s_/_\\_g')
        return 0
    fi

    if which explorer.exe 2>/dev/null | grep -q '^/mnt/c/Windows/explorer.exe'
    then
		if pwd | grep -q '/mnt/[a-z]'
		then
	        explorer.exe $(pwd | sed 's_^/mnt/\([a-z]\)[/]_\1:\\_;s_/_\\_g')
	        return 0
		else
			echo "Invalid pwd"
			return 1
		fi
    fi
    echo "No browser found"
    return 1
}

function tgo()
{
	local TMUX_SESSION_NAME=0
	[ -n "$1" ] && TMUX_SESSION_NAME="$1"
	tmux start-server
	if [ -z "$TMUX" ]; then
		# new-session -A not supported on tmux versions < 1.9
		#tmux new-session -A -s $TMUX_SESSION_NAME
		if  tmux has-session -t $TMUX_SESSION_NAME 2>/dev/null
		then tmux attach-session -t $TMUX_SESSION_NAME
		else tmux new-session -s $TMUX_SESSION_NAME
		fi
	else
		echo "Running in a Tmux session ($TMUX)"
	fi
}

function tmux-buffers()
{
	local buf=""
	cd /opt/screen/ || return 1
	for buf in scbuf.[0-9]*
	do 
		if [ -r $buf ]
		then
			#echo "\033[1;31m=== Buffer #$i ===\033[0m"
			head -v -n 20 $buf
			echo
		fi
	done | less #-R
}

# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -hl'
alias la='ls -hA'
alias lla='ls -hlA'
alias l='ls -hCF'

