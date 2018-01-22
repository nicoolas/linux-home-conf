#!/bin/sh

f_new_window() {
    WINDOW_ID=$((WINDOW_ID+1))
    WINDOW_NAME="$1"
    echo -n ">>> $WINDOW_NAME"
}

SESSION=_Session-1_
WINDOW_ID=0
tmux new-session -s $SESSION -d

f_new_window "htop"
tmux new-window -t $SESSION:$WINDOW_ID -n "$WINDOW_NAME" -c ~/
tmux send-keys "htop" C-m

#tmux split-window -t $SESSION:$WINDOW_ID -v -c ~/
#tmux split-window -t $SESSION:$WINDOW_ID -h -c ~/
tmux select-window -t $SESSION:0

SESSION=_Session-2_
WINDOW_ID=0
tmux new-session -s $SESSION -d

f_new_window "..."
tmux new-window -t $SESSION:$WINDOW_ID -n "$WINDOW_NAME"
tmux send-keys "# ..." C-m


