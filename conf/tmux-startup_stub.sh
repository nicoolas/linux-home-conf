#!/bin/sh

# send-keys:
# Ctrl keys may be prefixed with ‘C-’ or ‘^’, and Alt (meta) with ‘M-’.
# The following special key names are accepted:
#     Up, Down, Left, Right, BSpace, BTab, DC (Delete),
#     End, Enter, Escape, F1 to F20, Home, IC (Insert),
#     NPage/PageDown/PgDn, PPage/PageUp/PgUp, Space, and Tab.

f_window() {
    WINDOW_NAME="$1"
	shift 1
	if [ "$WINDOW_ID_NEXT" = "0" ]
	then
		tmux new-session -s $SESSION -d -n "$WINDOW_NAME" "$@"
	else
		tmux new-window -t $SESSION:$WINDOW_ID_NEXT -n "$WINDOW_NAME" "$@"
	fi
    echo "--> $SESSION:$WINDOW_ID_NEXT | $WINDOW_NAME"
	WINDOW_ID=$WINDOW_ID_NEXT
    WINDOW_ID_NEXT=$((WINDOW_ID_NEXT+1))
}

f_session() {
	SESSION="$1"
	WINDOW_ID="0"
	WINDOW_ID_NEXT="0"

    if ! tmux start-server
    then
        echo "ERROR: Failed to start Tmux server, aborting."
        exit 1
    fi

    if tmux has-session -t "$SESSION" 2>/dev/null
    then
        echo "ERROR: Session '$SESSION' already exists"
        return 1
    fi

	echo
    echo ">>> $SESSION"
}

f_send_keys() {
	sleep 0.2
	for k in "$@"
	do
		tmux send-keys "$k"
	done
}

# = = = = = = = = = = = = = = = = = = =
#f_session "my_session"
#f_window "Window-A" -c ~/
#f_window "Logs" -c /var/log/
#f_send_keys "tail -f /var/log/syslog"

#tmux split-window -t $SESSION:$WINDOW_ID -v -c ~/
#tmux split-window -t $SESSION:$WINDOW_ID -h -c ~/
#tmux select-window -t $SESSION:0

