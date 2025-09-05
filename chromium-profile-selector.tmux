#!/usr/bin/env bash

# FILENAME: chromium-profile-selector.tmux
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, September 3rd, 2025
# ORIGIN: https://github.com/zachary-krepelka/tmux-chromium-profile-selector.git

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/scripts

tmux bind-key -N 'Chromium Profile Selector' P run-shell -c "$scripts" "bash launch-menu.sh"
