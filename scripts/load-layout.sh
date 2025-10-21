#! /usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/variables.sh"

session_name=$1
session_dir=$2

tmux new-session -ds "$session_name" -c "$session_dir"

if [ ! -f "$layouts_dir/$session_name" ]; then
    tmux display-message "Session file $session_name not found. Creating empty session."
    return
fi

tmux display-message "Loading session $session_name."

t=$(printf '\t')

window_exists() {
    local window_index=$1
    tmux list-windows -t "$session_name" -F "#{window_index}" 2>/dev/null |
        \grep -q "^$window_index$"
}

pane_exists() {
    local window_index=$1
    local pane_index=$2
    tmux list-panes -t "$session_name:$window_index" -F "#{pane_index}" 2>/dev/null |
        \grep -q "^$pane_index$"
}

# Restore all panes.
grep '^pane' "$layouts_dir/$session_name" |
    while IFS=$t read -r line_type window_index pane_index pane_current_path pane_full_command; do
        # Create new windows as required.
        if ! window_exists "$window_index"; then
            tmux new-window -t "$session_name:$window_index"
        fi

        if pane_exists "$window_index" "$pane_index"; then
            # Overwrite existing pane.
            pane_id="$(tmux display-message -p -F "#{pane_id}" -t "$session_name:$window_index")"
            tmux split-window -t "$session_name:$window_index" -c "$pane_current_path" ${pane_full_command:+"$pane_full_command; exec $SHELL"}
            tmux kill-pane -t "$pane_id"
        else
            # Create new pane
            tmux split-window -t "$session_name:$window_index" -c "$pane_current_path" ${pane_full_command:+"$pane_full_command; exec $SHELL"}
        fi
    done 

# Restore window configuration.
grep '^window' "$layouts_dir/$session_name" |
    while IFS=$t read -r line_type window_index window_name window_layout automatic_rename; do
        tmux rename-window -t "$session_name:$window_index" "$window_name"
        tmux select-layout -t "$session_name:$window_index" "$window_layout"
        tmux select-pane -t "$session_name:$window_index.{top-left}"

        # Restore automatic renaming.
        if [ "$automatic_rename" = "on" ]; then
            tmux set-option -t "${session_name}:${window_index}" automatic-rename "$automatic_rename"
        fi
    done

# Set first window as active.
tmux switch-client -t "$session_name:^"
