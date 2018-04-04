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
	if [ "$WINDOW_ID" = "_" ]
	then
	    WINDOW_ID=0
		tmux new-session -s $SESSION -d -n "$WINDOW_NAME" "$@"
	else
		tmux new-window -t $SESSION:$WINDOW_ID -n "$WINDOW_NAME" "$@"
	fi
    echo "--> $SESSION:$WINDOW_ID | $WINDOW_NAME"
    WINDOW_ID=$((WINDOW_ID+1))
}

f_session() {
	SESSION="$1"
	WINDOW_ID="_"
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


#tmux split-window -t $SESSION:$WINDOW_ID -v -c ~/
#tmux split-window -t $SESSION:$WINDOW_ID -h -c ~/
#tmux select-window -t $SESSION:0


# = = = = = = = = = = = = = = = = = = =
#DEFAULT_SESSION=0
#f_session $DEFAULT_SESSION
#f_window "_-_" -c ~/


#tmux select-window -t $DEFAULT_SESSION

