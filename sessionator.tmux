#! /usr/bin/env bash
CURRENTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux bind S run "$CURRENTDIR/scripts/save-layout.sh"
tmux bind R command-prompt -p "Enter session to load:" "run '$CURRENTDIR/scripts/load-layout.sh %%'"
