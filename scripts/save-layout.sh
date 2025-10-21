#! /usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/variables.sh"

session=$(tmux display-message -p '#S')

mkdir -p "$layouts_dir"
t=$(printf '\t')

# Create an empty session file.
:>"$layouts_dir/$session"

# Save panes.
tmux list-panes -s -F "#I$t#P$t#{pane_current_path}$t#{pane_pid}" |
    while IFS=$t read -r window_index pane_index pane_current_path pane_pid; do
        full_command=$(ps -ao "ppid,args" | sed "s/^ *//" | grep "^${pane_pid}" | cut -d' ' -f2-)
        echo "pane$t$window_index$t$pane_index$t$pane_current_path$t$full_command" >> "$layouts_dir/$session"
    done

# Save window configuration.
tmux list-windows -F "#I$t#{window_name}$t#{window_layout}" |
    while IFS=$t read -r window_index window_name window_layout; do
        automatic_rename="$(tmux show-window-options -vt "${session}:${window_index}" automatic-rename)"
        # If the option was unset, that means it is on implicitly?
        [ -z "${automatic_rename}" ] && automatic_rename="on"
        echo "window$t$window_index$t$window_name$t$window_layout$t$automatic_rename" >> "$layouts_dir/$session"
    done

tmux display-message "Session ${session} saved."
