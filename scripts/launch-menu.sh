#!/usr/bin/env bash

# FILENAME: launch-menu.sh
# AUTHOR: Zachary Krepelka
# DATE: Thursday, September 4th, 2025
# ORIGIN: https://github.com/zachary-krepelka/tmux-chromium-profile-selector.git

error() {
	local message="$1" plugin=chromium-profile-selector
	tmux display-message -p "$plugin: error: $message"
	exit 0
}

executable="$(tmux show -gv @chromium_exec)" &&
	type -P "$executable" > /dev/null ||
	error 'unresolved chromium executable'

localstate="$(tmux show -gv @chromium_data)" &&
	test -f "$localstate" ||
	error 'unresolved local state file'

jq --arg executable "$executable" -rf create-menu.jq "$localstate" | tmux source -

# vim: tw=80 ts=4 sw=4 noet
