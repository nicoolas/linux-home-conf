
alias slogs='sudo tail -n 40 -f /var/log/syslog'
alias grep='grep --color=auto'

alias dpkg_disk_usage="dpkg-query -Wf '\${Installed-Size}\t\${Package}\t\${Priority}\n\' | egrep '\s(optional|extra)' | cut -f 1,2 | sort -nr"

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
    echo "No browser found"
    return 1
}

function tgo()
{
	local DEFAULT_TMUX_SESSION_NAME=0
	tmux start-server
	if [ -z "$TMUX" ]; then
		# new-session -A not supported on tmux versions < 1.9
		#tmux new-session -A -s $DEFAULT_TMUX_SESSION_NAME
		if  tmux has-session -t $DEFAULT_TMUX_SESSION_NAME 2>/dev/null
		then tmux attach-session -t $DEFAULT_TMUX_SESSION_NAME
		else tmux new-session -s $DEFAULT_TMUX_SESSION_NAME
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

