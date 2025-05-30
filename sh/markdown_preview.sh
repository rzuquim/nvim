#!/bin/sh

nvim_pid="$1"
url="$2"

qutebrowser --target window -C ~/.config/nvim/configs/qutebrowser.py "$url" &
qb_pid=$!
qb_pid_file="/tmp/nvim_preview_${nvim_pid}.pid"
echo "$qb_pid" > "$qb_pid_file"

# NOTE: poller to ensure the browser quits if we close nvim
(
    while kill -0 "$nvim_pid" 2>/dev/null && test -f "$qb_pid_file"; do
        sleep 5
    done
    kill "$qb_pid" 2>/dev/null
) &
