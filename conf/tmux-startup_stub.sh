#!/bin/sh

# send-keys:
# Ctrl keys may be prefixed with ‘C-’ or ‘^’, and Alt (meta) with ‘M-’.
# The following special key names are accepted:
#     Up, Down, Left, Right, BSpace, BTab, DC (Delete),
#     End, Enter, Escape, F1 to F20, Home, IC (Insert),
#     NPage/PageDown/PgDn, PPage/PageUp/PgUp, Space, and Tab.

TMUX_CMD=tmux
[ -n "$tmux_socket" ] && TMUX_CMD="$TMUX_CMD -S $tmux_socket"

f_window() {
    WINDOW_NAME="$1"
	shift 1
	if [ "$WINDOW_ID_NEXT" = "0" ]
	then
		$TMUX_CMD new-session -s $SESSION -d -n "$WINDOW_NAME" "$@"
	else
		$TMUX_CMD new-window -t $SESSION:$WINDOW_ID_NEXT -n "$WINDOW_NAME" "$@"
	fi
    echo "--> $SESSION:$WINDOW_ID_NEXT | $WINDOW_NAME"
	WINDOW_ID=$WINDOW_ID_NEXT
    WINDOW_ID_NEXT=$((WINDOW_ID_NEXT+1))
}

f_session() {
	SESSION="$1"
	WINDOW_ID="0"
	WINDOW_ID_NEXT="0"

    if ! $TMUX_CMD start-server
    then
        echo "ERROR: Failed to start Tmux server, aborting."
        exit 1
    fi
	if [ -n "$tmux_socket_group" ]
	then
		chgrp $tmux_socket_group $tmux_socket
	fi

    if $TMUX_CMD has-session -t "$SESSION" 2>/dev/null
    then
        echo "ERROR: Session '$SESSION' already exists"
        return 1
    fi

	echo
    [ -n "$tmux_socket" ] && local _socket_msg=" ($tmux_socket)"
    echo ">>> $SESSION$_socket_msg"
}

# Somehow, in scripts, the split-window command
# does not change the current pane ID
# We rememeber the PaneId and reuse it here with the '-t' option
# -t -> uses env variable _TMUX_LATEST_ID for target pane
f_send_keys() {
    local target_pane_id=""
    if [ "$1" = "-t" ]
    then
        [ -n "$_TMUX_LATEST_ID" ] && target_pane_id="-t$_TMUX_LATEST_ID"
        shift
    fi
    sleep 0.1
    for k in "$@"
    do
        $TMUX_CMD send-keys $target_pane_id "$k"
    done
}

f_split_window() {
    _TMUX_LATEST_ID=$($TMUX_CMD split-window -P -t $SESSION:$WINDOW_ID "$@")
    export _TMUX_LATEST_ID
}

# = = = = = = = = = = = = = = = = = = =
#f_session "my_session"
#f_window "Window-A" -c ~/
#f_window "Logs" -c /var/log/
#f_send_keys "tail -f /var/log/syslog"
#f_split_window [-v|-h] -c ~/
#
#$TMUX_CMD select-window -t $SESSION:0

